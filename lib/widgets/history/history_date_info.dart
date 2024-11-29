import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDateInfo extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const HistoryDateInfo({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          '${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}