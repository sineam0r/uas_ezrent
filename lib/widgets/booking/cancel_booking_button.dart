import 'package:flutter/material.dart';

class CancelBookingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CancelBookingButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.cancel),
        label: const Text('Batalkan Booking'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}