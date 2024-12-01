import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/widgets/detail/vehicle_booking_button.dart';
import 'package:uas_ezrent/widgets/detail/vehicle_info_row.dart';
import 'package:uas_ezrent/widgets/detail/vehicle_price_section.dart';

class VehicleDetailScreen extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  bool _isFavorite = false;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final favoriteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .where('vehicleId', isEqualTo: widget.vehicle.id)
          .get();

      setState(() {
        _isFavorite = favoriteSnapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  int get _rentalDuration {
    if (_startDate != null && _endDate != null) {
      if (_startDate!.isAfter(_endDate!)) {
        return 0;
      }
      return _endDate!.difference(_startDate!).inDays + 1;
    }
    return 0;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = isStart ? DateTime.now() : _startDate ?? DateTime.now();
    DateTime firstDate = isStart ? DateTime.now() : _startDate ?? DateTime.now();
    DateTime lastDate = DateTime.now().add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueAccent,
            hintColor: Colors.blueAccent,
            colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        if (_startDate != null && _endDate != null && _startDate!.isAfter(_endDate!)) {
          _startDate = null;
          _endDate = null;
        }
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login untuk menambahkan favorit.')),
      );
      return;
    }

    try {
      final favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites');

      if (_isFavorite) {
        final querySnapshot = await favoritesRef
            .where('vehicleId', isEqualTo: widget.vehicle.id)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kendaraan dihapus dari favorit')),
        );
      } else {
        await favoritesRef.add({
          'vehicleId': widget.vehicle.id,
          'vehicleName': widget.vehicle.name,
          'vehicleDetails': '${widget.vehicle.brand} - ${widget.vehicle.year}',
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kendaraan berhasil ditambahkan ke favorit!')),
        );
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah status favorit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final VehicleModel vehicle = widget.vehicle;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          vehicle.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
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
                  Row(
                    children: [
                      Text(
                        vehicle.brand,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        vehicle.name,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  VehicleInfoRow(
                    icon: Icons.car_rental,
                    label: 'Tipe',
                    value: vehicle.type,
                  ),
                  VehicleInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Tahun',
                    value: vehicle.year.toString(),
                  ),
                  VehicleInfoRow(
                    icon: Icons.settings,
                    label: 'Transmisi',
                    value: vehicle.transmission,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Durasi Rental',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _selectDate(context, true),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                          ),
                          child: Text(
                            _startDate != null
                                ? DateFormat('dd/MM/yyyy').format(_startDate!)
                                : 'Pilih Tanggal Mulai',
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _selectDate(context, false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                          ),
                          child: Text(
                            _endDate != null
                                ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                : 'Pilih Tanggal Akhir',
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  VehiclePriceSection(
                    vehicle: vehicle,
                    selectedRentalDuration: _rentalDuration,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: VehicleBookingButton(
        vehicle: widget.vehicle,
        selectedRentalDuration: _rentalDuration,
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }
}