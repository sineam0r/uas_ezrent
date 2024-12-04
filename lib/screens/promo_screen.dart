import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/promo.dart';
import 'package:uas_ezrent/widgets/promo/promo_item_card.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  List<PromoModel> _generatePromos() {
    return [
      PromoModel(
        title: 'Diskon 50% Minggu Ini!',
        description: 'Untuk semua kendaraan baru',
        code: 'NEWWEEK50',
        discount: 0.5,
        validUntil: DateTime(2024, 12, 31),
      ),
      PromoModel(
        title: 'Promo Akhir Tahun',
        description: 'Hemat sampai Rp 100.000',
        code: 'NEWYEAR100',
        discount: 100000,
        validUntil: DateTime(2024, 12, 25),
      ),
      PromoModel(
        title: 'Diskon Motor Baru',
        description: 'Khusus kendaraan roda dua',
        code: 'MOTOR20',
        discount: 0.2,
        validUntil: DateTime(2024, 12, 02),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final promos = _generatePromos();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Promo',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: promos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return PromoItemCard(promo: promos[index]);
        },
      ),
    );
  }
}