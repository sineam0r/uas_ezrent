import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/vehicle.dart';

class BookingVehicleDetails extends StatelessWidget {
  final VehicleModel vehicle;
  final DateTime startDate;
  final DateTime endDate;

  const BookingVehicleDetails({
    super.key,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Kendaraan',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${vehicle.brand} ${vehicle.name}',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mulai Sewa',
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(startDate),
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Selesai Sewa',
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(endDate),
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}