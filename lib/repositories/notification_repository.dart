import '../models/notification_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notifications';

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final snapshot = await _firestore.collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => NotificationModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<void> markAsRead(String id) async {
    await _firestore.collection(_collection).doc(id).update({'isRead': true});
  }

  Future<void> createNotification(NotificationModel notification) async {
    await _firestore.collection(_collection).add(notification.toJson());
  }
}

