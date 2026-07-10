import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../repositories/queue_repository.dart';

class QueueProvider extends ChangeNotifier {
  final QueueRepository _repository = QueueRepository();
  QueueModel? _liveQueue;
  bool _isLoading = false;

  QueueModel? get liveQueue => _liveQueue;
  bool get isLoading => _isLoading;

  Future<void> fetchLiveQueue(String doctorId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _liveQueue = await _repository.getLiveQueue(doctorId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> callNextPatient() async {
    if (_liveQueue == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      _liveQueue = await _repository.nextPatient(_liveQueue!.id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
