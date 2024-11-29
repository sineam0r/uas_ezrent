import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_ezrent/models/booking.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addBooking(BookingModel booking) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final bookingData = booking.toMap();
      bookingData['userId'] = currentUser.uid;
      bookingData['status'] = 'pending';

      final docRef = await _firestore.collection('bookings').add(bookingData);

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
    } catch (e) {
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
    } catch (e) {
      print('Error deleting booking: $e');
      rethrow;
    }
  }
}