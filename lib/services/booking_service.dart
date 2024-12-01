// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/services/notification_service.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();

  Future<String> addBooking(BookingModel booking) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Pengguna tidak terautentikasi.');
      }

      final bookingData = booking.toMap();
      bookingData['userId'] = currentUser.uid;
      bookingData['status'] = 'pending';

      final docRef = await _firestore.collection('bookings').add(bookingData);

      await _notificationService.addNotification(
        title: 'Booking Berhasil',
        message: 'Anda berhasil membooking ${booking.vehicleName}',
        bookingId: docRef.id,
        type: 'booking_created',
      );

      _delayedStatusUpdate(docRef.id);

      return docRef.id;
    } catch (e) {
      print('Error adding booking: $e');
      rethrow;
    }
  }

  void _delayedStatusUpdate(String bookingId) {
    Future.delayed(Duration(seconds: Random().nextInt(11) + 5), () async {
      try {
        final bookingDoc = await _firestore.collection('bookings').doc(bookingId).get();
        if (bookingDoc.exists && bookingDoc.data()?['status'] == 'pending') {
          await updateBookingStatus(bookingId, 'confirmed');
        }
      } catch (e) {
        print('Error in delayed status update: $e');
      }
    });
  }

  Stream<List<BookingModel>> getUserBookings() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
              .toList();
        }).handleError((error) {
          print('Error fetching bookings: $error');
          return <BookingModel>[];
        });
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
      });

      await _notificationService.addNotification(
        title: 'Status Booking Diperbarui',
        message: 'Status booking Anda telah diubah menjadi $status',
        bookingId: bookingId,
        type: 'booking_status_update',
      );

    } catch (e) {
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      print('Attempting to delete booking: $bookingId');

      final bookingDoc = await _firestore.collection('bookings').doc(bookingId).get();
      final bookingData = bookingDoc.data();

      print('Booking data: $bookingData');

      await _firestore.collection('bookings').doc(bookingId).delete();
      print('Booking deleted successfully');

      if (bookingData != null) {
        await _notificationService.addNotification(
          title: 'Booking Dihapus',
          message: 'Booking ${bookingData['vehicleName']} telah dihapus',
          bookingId: bookingId,
          type: 'booking_deleted',
        );
      }
    } catch (e) {
      print('Error deleting booking: $e');
      rethrow;
    }
  }
}