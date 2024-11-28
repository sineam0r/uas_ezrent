import 'package:flutter/material.dart';

class FavoriteEmptyState extends StatelessWidget {
  final bool isLoggedIn;

  const FavoriteEmptyState({
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
            Icons.favorite_border,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isLoggedIn
                ? 'Anda belum memiliki kendaraan favorit'
                : 'Silakan login untuk melihat favorit',
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