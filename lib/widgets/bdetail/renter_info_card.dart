import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/booking.dart';

class RenterInfoCard extends StatelessWidget {
  final BookingModel booking;
  final String name;
  final String phoneNumber;
  final String email;
  final String address;

  const RenterInfoCard({
    super.key,
    required this.booking,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              Icons.person,
              'Nama Lengkap',
              name,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.phone,
              'Nomor Telepon',
              phoneNumber,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.email,
              'Email',
              email,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on,
              'Alamat',
              address,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
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