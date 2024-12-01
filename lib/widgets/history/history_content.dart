import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/widgets/history/history_empty_state.dart';
import 'package:uas_ezrent/widgets/history/history_list_item.dart';

class HistoryContent extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<BookingModel>? bookings;
  final Function(BookingModel) onDelete;
  final Function(BookingModel) onBookingTap;

  const HistoryContent({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.bookings,
    required this.onDelete,
    required this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: GoogleFonts.poppins(color: Colors.red),
        ),
      );
    }

    if (bookings == null || bookings!.isEmpty) {
      return const HistoryEmptyState(isLoggedIn: true);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings!.length,
      itemBuilder: (context, index) {
        final booking = bookings![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: HistoryListItem(
            booking: booking,
            onTap: () => onBookingTap(booking),
            onDelete: () => onDelete(booking),
          ),
        );
      },
    );
  }
}