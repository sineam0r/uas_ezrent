import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/utils/booking_status.dart';
import 'package:uas_ezrent/widgets/booking/cancel_booking_button.dart';
import 'package:uas_ezrent/widgets/booking/rental_detail_card.dart';
import 'package:uas_ezrent/widgets/booking/vehicle_info_card.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingModel booking;
  final BookingService _bookingService = BookingService();

  BookingDetailScreen({
    super.key,
    required this.booking
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Detail Rental',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VehicleInfoCard(
                vehicleName: '${booking.vehicleBrand} ${booking.vehicleName}',
                status: booking.status,
                statusColor: BookingStatus.getStatusColor(booking.status),
              ),
              RentalDetailCard(
                startDate: booking.startDate,
                endDate: booking.endDate,
                rentalDuration: booking.rentalDuration,
                paymentMethod: booking.paymentMethod,
                totalPrice: booking.totalPrice,
              ),
              if (booking.status == 'pending')
                CancelBookingButton(
                  onPressed: () => _showCancelConfirmation(context),
                ),
            ],
          ),
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
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
