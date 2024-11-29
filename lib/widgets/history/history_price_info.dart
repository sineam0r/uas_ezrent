import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPriceInfo extends StatelessWidget {
  final double price;

  const HistoryPriceInfo({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.attach_money,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          'Rp ${NumberFormat('#,###').format(price)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}