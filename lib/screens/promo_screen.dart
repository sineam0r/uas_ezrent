import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/promo.dart';
import 'package:uas_ezrent/widgets/promo/promo_item_card.dart';

class PromoScreen extends StatelessWidget {
  final List<PromoModel> promos = [
    PromoModel(
      title: 'Diskon 50% Minggu Ini!', 
      description: 'Untuk semua kendaraan baru', 
      code: 'NEWWEEK50',
      discount: 0.5,
      validUntil: DateTime.now().add(Duration(days: 7)),
    ),
    PromoModel(
      title: 'Promo Akhir Tahun', 
      description: 'Hemat sampai Rp 100.000', 
      code: 'NEWYEAR100',
      discount: 100000,
      validUntil: DateTime.now().add(Duration(days: 30)),
    ),
    PromoModel(
      title: 'Diskon Motor Baru', 
      description: 'Khusus kendaraan roda dua', 
      code: 'MOTOR20',
      discount: 0.2,
      validUntil: DateTime.now().add(Duration(days: 14)),
    ),
  ];

  PromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promos.length,
        itemBuilder: (context, index) {
          return PromoItemCard(promo: promos[index]);
        },
      ),
    );
  }
}