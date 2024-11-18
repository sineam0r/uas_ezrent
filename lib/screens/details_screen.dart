import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/screens/form_screen.dart';

class DetailsScreen extends StatelessWidget {
  final Vehicle vehicle;

  const DetailsScreen({
    required this.vehicle, super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.brand} ${vehicle.nama}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              vehicle.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.brand} ${vehicle.nama}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${vehicle.tarif.toStringAsFixed(0)}/hari',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Spesifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSpecItem(Icons.car_rental, 'Tipe', vehicle.type),
                  _buildSpecItem(Icons.settings, 'Transmisi', vehicle.transmisi),
                  _buildSpecItem(Icons.people, 'Kapasitas', '${vehicle.kapasitas} Orang'),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(vehicle.deskripsi),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vehicle.isAvailable
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormScreen(vehicle: vehicle)
                            )
                          );
                        }
                        : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: Text(
                        vehicle.isAvailable ? 'Sewa Sekarang' : 'Tidak Tersedia',
                        style: const TextStyle(
                          fontSize: 16
                        ),
                      ),
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}