import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/widgets/booking/detail_row.dart';

class RentalDetailCard extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final int rentalDuration;
  final String paymentMethod;
  final double totalPrice;

  const RentalDetailCard({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.rentalDuration,
    required this.paymentMethod,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Rental',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            DetailRow(
              label: 'Tanggal Mulai',
              value: DateFormat('dd/MM/yyyy').format(startDate),
            ),
            DetailRow(
              label: 'Tanggal Selesai',
              value: DateFormat('dd/MM/yyyy').format(endDate),
            ),
            DetailRow(
              label: 'Durasi Sewa',
              value: '$rentalDuration hari',
            ),
            DetailRow(
              label: 'Metode Pembayaran',
              value: paymentMethod,
            ),
            DetailRow(
              label: 'Total Harga',
              value: 'Rp ${NumberFormat('#,###').format(totalPrice)}',
              isHighlighted: true,
            ),
          ],
        ),
      ),
    );
  }
}