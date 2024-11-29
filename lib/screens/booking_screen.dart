import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/screens/confirmation_screen.dart';

class BookingScreen extends StatefulWidget {
  final VehicleModel vehicle;
  final int rentalDuration;
  final DateTime startDate;
  final DateTime endDate;

  const BookingScreen({
    super.key,
    required this.vehicle,
    required this.rentalDuration,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final BookingService _bookingService = BookingService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedPaymentMethod;
  final List<String> _paymentMethods = [
    'Transfer Bank',
    'Kartu Kredit',
    'E-Wallet',
  ];

  late DateTime _startDate;
  late DateTime _endDate;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _totalPrice = widget.vehicle.pricePerDay * widget.rentalDuration;
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        final booking = BookingModel(
          id: '',
          userId: '',
          vehicleId: widget.vehicle.id,
          vehicleName: widget.vehicle.name,
          vehicleBrand: widget.vehicle.brand,
          startDate: _startDate,
          endDate: _endDate,
          rentalDuration: widget.rentalDuration,
          totalPrice: _totalPrice,
          paymentMethod: _selectedPaymentMethod!,
        );

        final bookingId = await _bookingService.addBooking(booking);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              vehicleDetails: '${widget.vehicle.brand} ${widget.vehicle.name}',
              rentalDuration: widget.rentalDuration,
              totalPrice: _totalPrice,
              bookingId: bookingId,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat booking: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Booking'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.vehicle.brand} ${widget.vehicle.name}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Tanggal Mulai: ${DateFormat('dd/MM/yyyy').format(_startDate)}',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Tanggal Selesai: ${DateFormat('dd/MM/yyyy').format(_endDate)}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Durasi: ${widget.rentalDuration} hari',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Harga: Rp ${NumberFormat('#,###').format(_totalPrice)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Informasi Pribadi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan nama lengkap';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan nomor telepon';
                    }
                    if (!RegExp(r'^[0-9]{10,12}$').hasMatch(value)) {
                      return 'Nomor telepon tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan alamat lengkap';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Pilih Metode Pembayaran',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedPaymentMethod,
                  items: _paymentMethods
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Mohon pilih metode pembayaran';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Konfirmasi Booking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}