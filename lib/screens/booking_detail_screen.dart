import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/widgets/bdetail/rental_detail_card.dart';
import 'package:uas_ezrent/widgets/bdetail/cancel_booking_button.dart';
import 'package:uas_ezrent/widgets/bdetail/vehicle_info_card.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailScreen({
    super.key,
    required this.booking
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Detail Rental',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VehicleInfoCard(booking: booking),
              const SizedBox(height: 16),
              RentalDetailsCard(booking: booking),
              const SizedBox(height: 16),
              if (booking.status == 'pending')
                CancelBookingButton(booking: booking),
            ],
          ),
        ),
      ),
    );
  }
}