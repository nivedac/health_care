import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/queue_model.dart';

/// Manages the live daily queue state for a doctor.
///
/// Queue documents are scoped by [doctorId] + [date] (YYYY-MM-DD).
/// This ensures today's queue never includes advance bookings for future dates.
class QueueRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'queue';

  // --------------------------------------------------------------------------
  // HELPERS
  // --------------------------------------------------------------------------

  static String dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // --------------------------------------------------------------------------
  // READ
  // --------------------------------------------------------------------------

  /// Returns today's live queue for [doctorId].
  ///
  /// CHANGED: Now scopes to the **current date** using a compound query
  /// (doctorId + date). Advance bookings for future dates never appear here.
  ///
  /// Returns null if no queue exists for today. Reception must call
  /// [openDailyQueue] to create one.
  Future<QueueModel?> getLiveQueue(String doctorId) async {
    final today = dateKey(DateTime.now());
    final snapshot = await _firestore
        .collection(_collection)
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: today)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return QueueModel.fromJson({...doc.data(), 'id': doc.id});
    }
    return null;
  }

  /// Opens a new daily queue for [doctorId] (called by reception at clinic open).
  /// Returns the existing queue if already opened today.
  Future<QueueModel> openDailyQueue(String doctorId) async {
    final existing = await getLiveQueue(doctorId);
    if (existing != null) return existing;

    final newQueue = QueueModel(
      id: '',
      doctorId: doctorId,
      date: DateTime.now(),
      activeTokens: const [],
      currentToken: null,
    );
    final docRef =
        await _firestore.collection(_collection).add(newQueue.toJson());
    return newQueue.copyWith(id: docRef.id);
  }

  // --------------------------------------------------------------------------
  // CALL NEXT PATIENT (ATOMIC TRANSACTION)
  // --------------------------------------------------------------------------

  /// Advances the queue to the next patient atomically.
  Future<QueueModel> nextPatient(String queueId) async {
    final docRef = _firestore.collection(_collection).doc(queueId);
    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception('Queue not found: $queueId');

      final queue =
          QueueModel.fromJson({...snapshot.data()!, 'id': snapshot.id});

      if (queue.activeTokens.isNotEmpty) {
        final nextToken = queue.activeTokens.first;
        final remainingTokens = queue.activeTokens.sublist(1);
        final updatedQueue = queue.copyWith(
          currentToken: nextToken,
          activeTokens: remainingTokens,
        );
        transaction.update(docRef, updatedQueue.toJson());
        return updatedQueue;
      }
      return queue;
    });
  }

  // --------------------------------------------------------------------------
  // ADD TOKEN TO QUEUE
  // --------------------------------------------------------------------------

  /// Adds a newly booked token to today's queue document.
  ///
  /// Uses [FieldValue.arrayUnion] for safe concurrent appends — multiple
  /// receptionists adding tokens simultaneously will not conflict.
  Future<void> addTokenToQueue({
    required String queueId,
    required Map<String, dynamic> tokenJson,
  }) async {
    await _firestore.collection(_collection).doc(queueId).update({
      'activeTokens': FieldValue.arrayUnion([tokenJson]),
    });
  }
}
