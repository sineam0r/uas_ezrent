import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/promo.dart';

class PromoItemCard extends StatelessWidget {
  final PromoModel promo;

  const PromoItemCard({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              promo.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              promo.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kode Promo: ${promo.code}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: promo.code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kode promo disalin')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Berlaku hingga: ${DateFormat('dd MMMM yyyy').format(promo.validUntil)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
