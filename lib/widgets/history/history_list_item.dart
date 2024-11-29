import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/screens/history_screen.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/widgets/history/history_date_info.dart';
import 'package:uas_ezrent/widgets/history/history_price_info.dart';
import 'package:uas_ezrent/widgets/history/status_chip.dart';

class HistoryListItem extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;
  final BookingService _bookingService = BookingService();

  HistoryListItem({
    super.key,
    required this.booking,
    required this.onTap,
  });

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Riwayat'),
          content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.blue[800])
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _bookingService.deleteBooking(booking.id);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking berhasil dihapus')),
                  );
                } catch (e) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus booking: $e')),
                  );
                }
              },
              child: Text(
                'Hapus',
                style: TextStyle(color: Colors.blue[800])
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${booking.vehicleBrand} ${booking.vehicleName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        StatusChip(status: booking.status),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _showDeleteConfirmationDialog(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                HistoryDateInfo(
                  startDate: booking.startDate,
                  endDate: booking.endDate,
                ),
                const SizedBox(height: 8),
                HistoryPriceInfo(price: booking.totalPrice),
              ],
            ),
          ),
        ),
      ),
    );
  }
}