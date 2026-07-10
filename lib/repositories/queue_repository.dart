import '../models/queue_model.dart';
import '../models/token_model.dart';

class QueueRepository {
  QueueModel _mockQueue = QueueModel(
    id: 'q1',
    doctorId: 'd1',
    date: DateTime.now(),
    activeTokens: [
      TokenModel(id: 't1', appointmentId: 'a1', tokenNumber: 'A01', issuedAt: DateTime.now()),
      TokenModel(id: 't2', appointmentId: 'a3', tokenNumber: 'A02', issuedAt: DateTime.now().add(const Duration(minutes: 5))),
    ],
    currentToken: TokenModel(id: 't0', appointmentId: 'a0', tokenNumber: 'A00', issuedAt: DateTime.now().subtract(const Duration(minutes: 10))),
  );

  Future<QueueModel> getLiveQueue(String doctorId) async {
    await Future.delayed(const Duration(seconds: 1));
    // For mock, returning the same queue regardless of doctorId
    return _mockQueue;
  }

  Future<QueueModel> nextPatient(String queueId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_mockQueue.activeTokens.isNotEmpty) {
      final nextToken = _mockQueue.activeTokens.first;
      final remainingTokens = _mockQueue.activeTokens.sublist(1);
      _mockQueue = _mockQueue.copyWith(
        currentToken: nextToken,
        activeTokens: remainingTokens,
      );
    }
    return _mockQueue;
  }
}
