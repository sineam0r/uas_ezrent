import 'package:flutter/material.dart';

class HistoryEmptyState extends StatelessWidget {
  final bool isLoggedIn;

  const HistoryEmptyState({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isLoggedIn
                ? 'Anda belum memiliki riwayat rental'
                : 'Silakan login untuk melihat riwayat rental',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}