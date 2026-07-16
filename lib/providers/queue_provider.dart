import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../models/token_model.dart';
import '../repositories/queue_repository.dart';
import 'notification_provider.dart';
import 'package:uuid/uuid.dart';
import '../core/error_handler.dart';

class QueueProvider extends ChangeNotifier {
  final QueueRepository _repository = QueueRepository();
  QueueModel? _liveQueue;
  bool _isLoading = false;

  static const int averageConsultationTime = 8; // minutes

  QueueModel? get liveQueue => _liveQueue;
  bool get isLoading => _isLoading;

  // Initialize with a mock queue if empty
  Future<void> fetchLiveQueue(String doctorId) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_liveQueue == null || _liveQueue!.doctorId != doctorId) {
        _liveQueue = await _repository.getLiveQueue(doctorId);
        
        // Setup initial mock tokens if empty for testing
        if (_liveQueue!.activeTokens.isEmpty) {
          _liveQueue = _liveQueue!.copyWith(
            activeTokens: [
              TokenModel(id: const Uuid().v4(), appointmentId: '', tokenNumber: 1, issuedAt: DateTime.now(), status: QueueStatus.inConsultation, patientName: 'Alexander Pierce', patientPhone: '+1 555-0101'),
              TokenModel(id: const Uuid().v4(), appointmentId: '', tokenNumber: 2, issuedAt: DateTime.now(), status: QueueStatus.waiting, patientName: 'Sarah McEvoy', patientPhone: '+1 555-0102'),
              TokenModel(id: const Uuid().v4(), appointmentId: '', tokenNumber: 3, issuedAt: DateTime.now(), status: QueueStatus.waiting, patientName: 'Daniel Martinez', patientPhone: '+1 555-0103'),
              TokenModel(id: const Uuid().v4(), appointmentId: '', tokenNumber: 4, issuedAt: DateTime.now(), status: QueueStatus.booked, patientName: 'Liam Henderson', patientPhone: '+1 555-0104'),
            ],
            currentToken: TokenModel(id: 'mock1', appointmentId: '', tokenNumber: 1, issuedAt: DateTime.now(), status: QueueStatus.inConsultation, patientName: 'Alexander Pierce', patientPhone: '+1 555-0101'),
          );
        }
      }
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateTokenStatus(String tokenId, QueueStatus status) {
    if (_liveQueue == null) return;
    
    final tokens = List<TokenModel>.from(_liveQueue!.activeTokens);
    final index = tokens.indexWhere((t) => t.id == tokenId);
    
    if (index != -1) {
      tokens[index] = tokens[index].copyWith(status: status);
      
      // Update current token if it's the one we are modifying
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

  void callNextPatient(NotificationProvider? notifs) {
    if (_liveQueue == null) return;
    
    // Complete the current one if it's in consultation
    if (_liveQueue!.currentToken != null && _liveQueue!.currentToken!.status == QueueStatus.inConsultation) {
      _updateTokenStatus(_liveQueue!.currentToken!.id, QueueStatus.completed);
    }
    
    // Find next waiting or arrived
    final tokens = _liveQueue!.activeTokens;
    final nextToken = tokens.cast<TokenModel?>().firstWhere(
      (t) => t?.status == QueueStatus.waiting || t?.status == QueueStatus.arrived,
      orElse: () => null,
    );
    
    if (nextToken != null) {
      _updateTokenStatus(nextToken.id, QueueStatus.inConsultation);
      _liveQueue = _liveQueue!.copyWith(currentToken: _liveQueue!.activeTokens.firstWhere((t) => t.id == nextToken.id));
      
      notifs?.addMockNotification(
        'patient_123', 
        'Your Token Is Being Called', 
        'Please proceed to Room 302. Doctor is ready.', 
        'alert'
      );
      
      notifyListeners();
      _checkRemainingPatients(notifs);
    } else {
      _liveQueue = _liveQueue!.copyWith(currentToken: null);
      notifyListeners();
    }
  }

  void recallPatient(String tokenId, NotificationProvider? notifs) {
    _updateTokenStatus(tokenId, QueueStatus.called);
    notifs?.addMockNotification(
      'patient_123', 
      'Missed Call', 
      'The doctor called you again. Please proceed to the room immediately.', 
      'alert'
    );
  }

  void skipPatient(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.skipped);
    // If the skipped patient was the current token, we should probably call next
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

  void cancelAppointment(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.cancelled);
  }

  void markPatientArrived(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.arrived);
  }

  void markPatientNotArrived(String tokenId) {
    _updateTokenStatus(tokenId, QueueStatus.skipped);
  }

  TokenModel? generateToken({
    required String patientName, 
    required String patientPhone,
    String? patientId,
    bool isWalkIn = false,
  }) {
    if (_liveQueue == null) return null;

    // Check if patient already has active booking today
    if (patientPhone.isNotEmpty) {
      final existing = _liveQueue!.activeTokens.where((t) => 
        t.patientPhone == patientPhone && 
        (t.status == QueueStatus.waiting || t.status == QueueStatus.booked || t.status == QueueStatus.arrived)
      );
      if (existing.isNotEmpty) {
        return null; // Already has active token
      }
    }

    final int nextTokenNum = _liveQueue!.activeTokens.length + 1;
    final newToken = TokenModel(
      id: const Uuid().v4(),
      appointmentId: 'mock_apt_${nextTokenNum}',
      tokenNumber: nextTokenNum,
      issuedAt: DateTime.now(),
      status: isWalkIn ? QueueStatus.waiting : QueueStatus.booked,
      patientName: patientName,
      patientPhone: patientPhone,
      patientId: patientId,
    );

    final updatedTokens = List<TokenModel>.from(_liveQueue!.activeTokens)..add(newToken);
    _liveQueue = _liveQueue!.copyWith(activeTokens: updatedTokens);
    notifyListeners();
    
    return newToken;
  }

  int getEstimatedWaitingTime(String tokenId) {
    if (_liveQueue == null) return 0;
    
    final token = _liveQueue!.activeTokens.cast<TokenModel?>().firstWhere((t) => t?.id == tokenId, orElse: () => null);
    if (token == null || token.status == QueueStatus.completed || token.status == QueueStatus.cancelled || token.status == QueueStatus.skipped) {
      return 0;
    }
    
    if (token.status == QueueStatus.inConsultation) return 0;
    
    // Count how many people are ahead in the queue (waiting, arrived)
    final aheadCount = _liveQueue!.activeTokens.where((t) {
      return (t.status == QueueStatus.waiting || t.status == QueueStatus.arrived) && t.tokenNumber < token.tokenNumber;
    }).length;
    
    // If there is someone currently in consultation, add 1 to ahead count
    final inConsultationCount = _liveQueue!.activeTokens.where((t) => t.status == QueueStatus.inConsultation || t.status == QueueStatus.called).length;
    
    return (aheadCount + inConsultationCount) * averageConsultationTime;
  }
  
  void _checkRemainingPatients(NotificationProvider? notifs) {
    if (_liveQueue == null) return;
    final waiting = _liveQueue!.activeTokens.where((t) => t.status == QueueStatus.waiting || t.status == QueueStatus.arrived).length;
    if (waiting == 5) {
      notifs?.addMockNotification(
        'patient_123', 
        'Only 5 Patients Remaining', 
        'Your turn is approaching soon. Please be near the clinic.', 
        'reminder'
      );
    }
  }
}
