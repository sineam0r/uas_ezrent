import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_ezrent/models/notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addNotification({
    required String title,
    required String message,
    String? bookingId,
    String? type,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final notification = NotificationModel(
      id: '',
      title: title,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
      bookingId: bookingId,
      type: type,
    );

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .add(notification.toMap());
  }

  Stream<List<NotificationModel>> getUserNotifications() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
          snapshot.docs.map((doc) =>
            NotificationModel.fromFirestore(doc)
          ).toList()
        );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}