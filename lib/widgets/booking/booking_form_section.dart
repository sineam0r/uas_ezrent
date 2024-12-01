import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingFormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double bottomPadding;

  const BookingFormSection({
    super.key,
    required this.title,
    required this.children,
    this.bottomPadding = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}