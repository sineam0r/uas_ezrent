import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/screens/booking_detail_screen.dart';
import 'package:uas_ezrent/widgets/history/history_empty_state.dart';
import 'package:uas_ezrent/widgets/history/history_list_item.dart';

class HistoryScreen extends StatelessWidget {
  final BookingService _bookingService = BookingService();

  HistoryScreen({super.key});

  Widget _buildHistoryContent(BuildContext context, List<BookingModel> bookings) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: HistoryListItem(
                    booking: booking,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailScreen(booking: booking),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Riwayat Rentalku',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: const HistoryEmptyState(isLoggedIn: false),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Riwayat Rentalku',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: _bookingService.getUserBookings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const HistoryEmptyState(isLoggedIn: true);
          }
          return _buildHistoryContent(context, snapshot.data!);
        },
      ),
    );
  }
}