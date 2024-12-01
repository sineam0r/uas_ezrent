import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingPriceSummary extends StatelessWidget {
  final double originalPrice;
  final double discountAmount;

  const BookingPriceSummary({
    super.key,
    required this.originalPrice,
    required this.discountAmount,
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
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Harga',
                  style: GoogleFonts.poppins(),
                ),
                Text(
                  'Rp ${NumberFormat('#,###').format(originalPrice)}',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            if (discountAmount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diskon',
                    style: GoogleFonts.poppins(color: Colors.green),
                  ),
                  Text(
                    '- Rp ${NumberFormat('#,###').format(discountAmount)}',
                    style: GoogleFonts.poppins(color: Colors.green),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp ${NumberFormat('#,###').format(originalPrice - discountAmount)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}