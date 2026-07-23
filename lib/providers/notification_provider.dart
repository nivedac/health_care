import 'dart:async';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';
import '../core/error_handler.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  StreamSubscription<List<NotificationModel>>? _subscription;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void fetchNotifications(String userId) {
    _isLoading = true;
    notifyListeners();
    
    _subscription?.cancel();
    _subscription = _repository.getNotificationsStream(userId).listen(
      (notifications) {
        _notifications = notifications;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e, stackTrace) {
        _isLoading = false;
        notifyListeners();
        ErrorHandler.handleError(e, stackTrace: stackTrace);
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
      // We don't need to manually update _notifications here since the stream will push the update
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
