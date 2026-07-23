import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../models/token_model.dart';
import '../models/notification_model.dart';
import '../repositories/queue_repository.dart';
import '../repositories/notification_repository.dart';
import 'notification_provider.dart';
import '../core/error_handler.dart';

/// Manages the real-time queue logic for the clinic.
///
/// The `QueueProvider` handles queue advancement (calling next patient,
/// marking arrived/completed/skipped) and estimated wait time calculation.
/// It interacts with [QueueRepository] for persistent state and
/// [NotificationProvider] to dispatch in-app alerts.
///
/// ## What this provider does NOT do
/// - It does NOT generate token numbers (handled atomically by [BookingRepository]).
/// - It does NOT create appointments (handled by [AppointmentProvider]).
///
/// ## Queue lifecycle
/// 1. Reception opens clinic → [openQueue] creates today's queue document
/// 2. Patient books → [BookingRepository] creates appointment + token counter
/// 3. Reception adds booked patient to queue → [addTokenToQueue]
/// 4. Reception calls next → [callNextPatient]
/// 5. Reception marks outcomes → [markPatientArrived], [skipPatient], etc.
class QueueProvider extends ChangeNotifier {
  final QueueRepository _repository = QueueRepository();
  QueueModel? _liveQueue;
  bool _isLoading = false;
  bool _isQueueOpen = false;

  /// Average time (in minutes) spent per patient consultation.
  /// Used for estimated wait time calculation.
  static const int averageConsultationTime = 8;

  QueueModel? get liveQueue => _liveQueue;
  bool get isLoading => _isLoading;
  bool get isQueueOpen => _isQueueOpen;

  // --------------------------------------------------------------------------
  // FETCH TODAY'S QUEUE
  // --------------------------------------------------------------------------

  /// Fetches today's live queue for [doctorId].
  ///
  /// No longer creates mock data. Returns the real queue from Firestore,
  /// scoped to today's date. If no queue exists for today, [liveQueue] will
  /// be null — the reception screen shows an "Open Clinic" button.
  Future<void> fetchLiveQueue(String doctorId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _liveQueue = await _repository.getLiveQueue(doctorId);
      _isQueueOpen = _liveQueue != null;
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------------------------
  // OPEN DAILY QUEUE (reception action at clinic open)
  // --------------------------------------------------------------------------

  /// Creates today's queue document for [doctorId].
  /// Called by reception when opening the clinic for the day.
  Future<void> openQueue(String doctorId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _liveQueue = await _repository.openDailyQueue(doctorId);
      _isQueueOpen = true;
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------------------------
  // ADD BOOKED TOKEN TO QUEUE
  // --------------------------------------------------------------------------

  /// Adds a booked patient's token to the live queue.
  ///
  /// Called after [AppointmentProvider.bookAppointment] succeeds.
  /// The token number was atomically assigned by [BookingRepository] —
  /// this just appends the token to the queue's activeTokens array
  /// using [FieldValue.arrayUnion] (safe for concurrent appends).
  Future<void> addTokenToQueue(TokenModel token) async {
    if (_liveQueue == null) return;
    try {
      await _repository.addTokenToQueue(
        queueId: _liveQueue!.id,
        tokenJson: token.toJson(),
      );
      // Optimistic update
      final updated = List<TokenModel>.from(_liveQueue!.activeTokens)..add(token);
      _liveQueue = _liveQueue!.copyWith(activeTokens: updated);
      notifyListeners();
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
    }
  }

  // --------------------------------------------------------------------------
  // TOKEN STATUS UPDATES
  // --------------------------------------------------------------------------

  void _updateTokenStatus(String tokenId, QueueStatus status) {
    if (_liveQueue == null) return;

    final tokens = List<TokenModel>.from(_liveQueue!.activeTokens);
    final index = tokens.indexWhere((t) => t.id == tokenId);

    if (index != -1) {
      tokens[index] = tokens[index].copyWith(status: status);

      TokenModel? current = _liveQueue!.currentToken;
      if (current?.id == tokenId) {
        current = tokens[index];
      }

      _liveQueue = _liveQueue!.copyWith(
        activeTokens: tokens,
        currentToken: current,
      );
      notifyListeners();
    }
  }

  // --------------------------------------------------------------------------
  // QUEUE ADVANCEMENT (reception actions)
  // --------------------------------------------------------------------------

  /// Calls the next patient in the queue.
  ///
  /// Automatically marks the currently consulting token as [QueueStatus.completed].
  /// Then advances to the first token with status [QueueStatus.waiting] or
  /// [QueueStatus.arrived], marking it [QueueStatus.inConsultation].
  void callNextPatient(NotificationProvider? notifs) async {
    if (_liveQueue == null) return;

    // Complete the current consultation
    if (_liveQueue!.currentToken != null &&
        _liveQueue!.currentToken!.status == QueueStatus.inConsultation) {
      _updateTokenStatus(_liveQueue!.currentToken!.id, QueueStatus.completed);
    }

    // Find next waiting or arrived
    final tokens = _liveQueue!.activeTokens;
    final nextToken = tokens.cast<TokenModel?>().firstWhere(
          (t) =>
              t?.status == QueueStatus.waiting ||
              t?.status == QueueStatus.arrived,
          orElse: () => null,
        );

    if (nextToken != null) {
      _updateTokenStatus(nextToken.id, QueueStatus.inConsultation);
      _liveQueue = _liveQueue!.copyWith(
          currentToken: _liveQueue!.activeTokens
              .firstWhere((t) => t.id == nextToken.id));

      if (nextToken.patientId != null && !nextToken.patientId!.startsWith('walkin_')) {
        await _sendRealNotification(
          nextToken.patientId!,
          'Your Token Is Being Called',
          'Please proceed to the consultation room. Doctor is ready.',
          'alert',
        );
      }

      notifyListeners();
      _checkRemainingPatients(nextToken.patientId);
    } else {
      _liveQueue = _liveQueue!.copyWith(currentToken: null);
      notifyListeners();
    }
  }

  void recallPatient(String tokenId, NotificationProvider? notifs) async {
    _updateTokenStatus(tokenId, QueueStatus.called);
    final token = _liveQueue?.activeTokens
        .cast<TokenModel?>()
        .firstWhere((t) => t?.id == tokenId, orElse: () => null);
    
    if (token?.patientId != null && !token!.patientId!.startsWith('walkin_')) {
      await _sendRealNotification(
        token.patientId!,
        'Missed Call',
        'The doctor called you again. Please proceed to the room immediately.',
        'alert',
      );
    }
  }

  void skipPatient(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.skipped);
    if (_liveQueue?.currentToken?.id == tokenId) {
      callNextPatient(null);
    }
  }

  void completeConsultation(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.completed);
    if (_liveQueue?.currentToken?.id == tokenId) {
      _liveQueue = _liveQueue!.copyWith(currentToken: null);
      notifyListeners();
    }
  }

  void cancelTokenInQueue(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.cancelled);
  }

  void markPatientArrived(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.arrived);
  }

  void markPatientNoShow(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.skipped);
  }

  // --------------------------------------------------------------------------
  // ESTIMATED WAIT TIME
  // --------------------------------------------------------------------------

  /// Calculates the estimated waiting time in minutes for [tokenId].
  int getEstimatedWaitingTime(String tokenId) {
    if (_liveQueue == null) return 0;

    final token = _liveQueue!.activeTokens
        .cast<TokenModel?>()
        .firstWhere((t) => t?.id == tokenId, orElse: () => null);

    if (token == null ||
        token.status == QueueStatus.completed ||
        token.status == QueueStatus.cancelled ||
        token.status == QueueStatus.skipped) {
      return 0;
    }

    if (token.status == QueueStatus.inConsultation) return 0;

    // Count patients ahead (waiting or arrived with smaller token number)
    final aheadCount = _liveQueue!.activeTokens.where((t) {
      return (t.status == QueueStatus.waiting ||
              t.status == QueueStatus.arrived) &&
          t.tokenNumber < token.tokenNumber;
    }).length;

    final inConsultationCount = _liveQueue!.activeTokens
        .where((t) =>
            t.status == QueueStatus.inConsultation ||
            t.status == QueueStatus.called)
        .length;

    return (aheadCount + inConsultationCount) * averageConsultationTime;
  }

  // --------------------------------------------------------------------------
  // INTERNAL
  // --------------------------------------------------------------------------

  Future<void> _sendRealNotification(String userId, String title, String body, String type) async {
    try {
      final notifRepo = NotificationRepository();
      await notifRepo.createNotification(
        NotificationModel(
          id: '', // Will be assigned by Firestore
          userId: userId,
          title: title,
          message: body,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );
    } catch (e, stack) {
      ErrorHandler.handleError(e, stackTrace: stack);
    }
  }

  void _checkRemainingPatients(String? patientId) async {
    if (_liveQueue == null || patientId == null || patientId.startsWith('walkin_')) return;
    final waiting = _liveQueue!.activeTokens
        .where((t) =>
            t.status == QueueStatus.waiting || t.status == QueueStatus.arrived)
        .length;
    if (waiting == 5) {
      await _sendRealNotification(
        patientId,
        'Only 5 Patients Remaining',
        'Your turn is approaching soon. Please be near the clinic.',
        'reminder',
      );
    }
  }
}
