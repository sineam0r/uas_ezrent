import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/screens/booking_detail_screen.dart';

class CancelBookingButton extends StatelessWidget {
  final BookingModel booking;
  final BookingService _bookingService = BookingService();

  CancelBookingButton({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showCancelConfirmation(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Batalkan Booking',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Booking'),
        content: const Text('Apakah Anda yakin ingin membatalkan booking ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _bookingService.updateBookingStatus(booking.id, 'cancelled');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BookingDetailScreen(booking: BookingModel(
              id: booking.id,
              userId: booking.userId,
              vehicleId: booking.vehicleId,
              vehicleName: booking.vehicleName,
              vehicleBrand: booking.vehicleBrand,
              startDate: booking.startDate,
              endDate: booking.endDate,
              rentalDuration: booking.rentalDuration,
              totalPrice: booking.totalPrice,
              paymentMethod: booking.paymentMethod,
              status: 'cancelled',
            )),
          ),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membatalkan booking: $e'),
          ),
        );
      }
    }
  }
}