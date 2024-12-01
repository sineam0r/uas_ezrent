import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmationScreen extends StatelessWidget {
  final String vehicleDetails;
  final int rentalDuration;
  final double totalPrice;
  final String bookingId;

  const ConfirmationScreen({
    super.key,
    required this.vehicleDetails,
    required this.rentalDuration,
    required this.totalPrice,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Konfirmasi Booking', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blueAccent,
                    size: 100,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Booking Berhasil!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Kendaraan: $vehicleDetails',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Durasi Rental: $rentalDuration hari',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Harga: Rp ${NumberFormat('#,###').format(totalPrice)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nomor Booking: $bookingId',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}