import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/widgets/bdetail/rental_detail_card.dart';
import 'package:uas_ezrent/widgets/bdetail/cancel_booking_button.dart';
import 'package:uas_ezrent/widgets/bdetail/renter_info_card.dart';
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
        title: Text(
          'Detail Rental',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Informasi Kendaraan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              VehicleInfoCard(booking: booking),
              const SizedBox(height: 24),
              Text(
                'Informasi Penyewa',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              RenterInfoCard(booking: booking),
              const SizedBox(height: 24),
              Text(
                'Detail Penyewaan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              RentalDetailsCard(booking: booking),
              const SizedBox(height: 24),
              if (booking.status == 'pending')
                CancelBookingButton(booking: booking),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}