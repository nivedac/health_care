import '../models/notification_model.dart';

class NotificationRepository {
  final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: 'n1',
      userId: 'u4',
      title: 'Appointment Confirmed',
      message: 'Your appointment for today is confirmed.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'n2',
      userId: 'u4',
      title: 'It is almost your turn!',
      message: 'You are next in line. Please be ready.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: true,
    ),
  ];

  Future<List<NotificationModel>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockNotifications.where((n) => n.userId == userId).toList();
  }

  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotifications[index] = _mockNotifications[index].copyWith(isRead: true);
    }
  }
}
