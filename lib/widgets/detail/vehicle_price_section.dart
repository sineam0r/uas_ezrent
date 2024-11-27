import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/vehicle.dart';

class VehiclePriceSection extends StatelessWidget {
  final VehicleModel vehicle;
  final int selectedRentalDuration;

  const VehiclePriceSection({
    super.key,
    required this.vehicle,
    required this.selectedRentalDuration,
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = vehicle.pricePerDay * selectedRentalDuration;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildPriceRow('Harga per Hari',
            'Rp ${vehicle.pricePerDay.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _buildPriceRow('Durasi Rental',
            '$selectedRentalDuration Hari'),
          const Divider(height: 16),
          _buildTotalPriceRow(totalPrice),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTotalPriceRow(double totalPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Harga',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          'Rp ${totalPrice.toStringAsFixed(0)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}