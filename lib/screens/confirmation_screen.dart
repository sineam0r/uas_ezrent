import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/screens/home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final String vehicleDetails;
  final int rentalDuration;
  final double totalPrice;

  const ConfirmationScreen({
    super.key,
    required this.vehicleDetails,
    required this.rentalDuration,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Berhasil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 24),
            const Text(
              'Selamat, Booking Anda berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Kendaraan: $vehicleDetails\nDurasi: $rentalDuration hari\nTotal Biaya: Rp ${NumberFormat('#,###').format(totalPrice)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.blue, width: 2),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Kembali ke Halaman Utama',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
