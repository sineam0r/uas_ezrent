import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/booking.dart';

class RenterInfoCard extends StatelessWidget {
  final BookingModel booking;

  const RenterInfoCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.person, 'Nama', booking.userName ?? 'Tidak tersedia'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.phone, 'Nomor Telepon', booking.userPhone ?? 'Tidak tersedia'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'Email', booking.userEmail ?? 'Tidak tersedia'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, 'Alamat', booking.userAddress ?? 'Tidak tersedia'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}