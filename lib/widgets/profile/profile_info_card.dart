import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfileInfoCard extends StatelessWidget {
  final String email;
  final DateTime? joinDate;

  const ProfileInfoCard({
    super.key,
    required this.email,
    this.joinDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Email: $email',
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            Text(
              'Bergabung sejak: ${joinDate != null
                ? DateFormat('dd MMMM yyyy').format(joinDate!)
                : ""}',
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}