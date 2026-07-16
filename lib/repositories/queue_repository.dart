import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/queue_model.dart';
import '../models/token_model.dart';

class QueueRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'queue';

  Future<QueueModel> getLiveQueue(String doctorId) async {
    // Usually one active queue per doctor per day.
    // For simplicity, we query by doctorId.
    final snapshot = await _firestore.collection(_collection)
        .where('doctorId', isEqualTo: doctorId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return QueueModel.fromJson({...doc.data(), 'id': doc.id});
    } else {
      // Create a default empty queue if not found
      final newQueue = QueueModel(
        id: '',
        doctorId: doctorId,
        date: DateTime.now(),
        activeTokens: const [],
        currentToken: null,
      );
      final docRef = await _firestore.collection(_collection).add(newQueue.toJson());
      return newQueue.copyWith(id: docRef.id);
    }
  }

  Future<QueueModel> nextPatient(String queueId) async {
    final docRef = _firestore.collection(_collection).doc(queueId);
    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception('Queue not found');

      final queue = QueueModel.fromJson({...snapshot.data()!, 'id': snapshot.id});
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
}

