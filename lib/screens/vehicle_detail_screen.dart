import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/widgets/detail/vehicle_booking_button.dart';
import 'package:uas_ezrent/widgets/detail/vehicle_info_row.dart';
import 'package:uas_ezrent/widgets/detail/vehicle_price_section.dart';
import 'package:intl/intl.dart';

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
            primaryColor: Colors.blue,
            hintColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: Colors.blue),
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

  @override
  Widget build(BuildContext context) {
    final VehicleModel vehicle = widget.vehicle;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                vehicle.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${vehicle.brand} ${vehicle.name}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
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
                    const Text(
                      'Durasi Rental',
                      style: TextStyle(
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
                              side: const BorderSide(color: Colors.blue),
                            ),
                            child: Text(
                              _startDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_startDate!)
                                  : 'Pilih Tanggal Mulai',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _selectDate(context, false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blue),
                            ),
                            child: Text(
                              _endDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                  : 'Pilih Tanggal Akhir',
                              style: const TextStyle(color: Colors.black),
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
            ]),
          ),
        ],
      ),
      bottomNavigationBar: VehicleBookingButton(
        vehicle: widget.vehicle,
        selectedRentalDuration: _rentalDuration,
      ),
    );
  }
}

