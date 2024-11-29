import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/screens/booking_detail_screen.dart';
import 'package:uas_ezrent/widgets/history/history_empty_state.dart';
import 'package:uas_ezrent/widgets/history/history_list_item.dart';

class HistoryScreen extends StatelessWidget {
  final BookingService _bookingService = BookingService();

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Rentalku'),
        ),
        body: const HistoryEmptyState(isLoggedIn: false),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Rental'),
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: _bookingService.getUserBookings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const HistoryEmptyState(isLoggedIn: true);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final booking = snapshot.data![index];
              return HistoryListItem(
                booking: booking,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailScreen(booking: booking),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}