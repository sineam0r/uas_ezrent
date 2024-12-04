import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/screens/booking_screen.dart';

class VehicleBookingButton extends StatelessWidget {
  final VehicleModel vehicle;
  final int selectedRentalDuration;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isVehicleAvailable;

  const VehicleBookingButton({
    super.key,
    required this.vehicle,
    required this.selectedRentalDuration,
    required this.startDate,
    required this.endDate,
    required this.isVehicleAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBookingEnabled =
      startDate != null &&
      endDate != null &&
      selectedRentalDuration > 0 &&
      isVehicleAvailable;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isBookingEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(
                      vehicle: vehicle,
                      startDate: startDate!,
                      endDate: endDate!,
                      rentalDuration: selectedRentalDuration,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          !isVehicleAvailable
            ? 'Kendaraan Tidak Tersedia'
            : (isBookingEnabled
              ? 'Lanjutkan Booking'
              : 'Pilih Tanggal Rental'),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}