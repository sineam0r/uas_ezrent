import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/screens/booking_screen.dart';

class VehicleBookingButton extends StatelessWidget {
  final VehicleModel vehicle;
  final int selectedRentalDuration;
  final VoidCallback? onBooking;

  const VehicleBookingButton({
    super.key,
    required this.vehicle,
    required this.selectedRentalDuration,
    this.onBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: vehicle.isAvailable
            ? () {
                if (onBooking != null) {
                  onBooking!();
                } else {
                  if (selectedRentalDuration == 0) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Peringatan'),
                          content: const Text(
                            'Mohon pilih durasi rental terlebih dahulu'
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Oke'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          vehicle: vehicle,
                          rentalDuration: selectedRentalDuration,
                        ),
                      ),
                    );
                  }
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          vehicle.isAvailable ? 'Booking Sekarang' : 'Tidak Tersedia',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

