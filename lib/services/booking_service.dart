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

      final docRef = await _firestore.collection('bookings').add(bookingData);
      return docRef.id;
    } catch (e) {
      print('Error adding booking: $e');
      rethrow;
    }
  }

  Stream<List<BookingModel>> getUserBookings() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('startDate', descending: true)
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