import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/promo.dart';
import 'package:uas_ezrent/models/user.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/screens/promo_screen.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/services/profile_service.dart';
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
  final ProfileService _profileService = ProfileService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _promoCodeController = TextEditingController();

  String? _selectedPaymentMethod;
  final List<String> _paymentMethods = [
    'Transfer Bank',
    'Kartu Kredit',
    'E-Wallet',
  ];

  late DateTime _startDate;
  late DateTime _endDate;
  late double _originalPrice;
  late double _totalPrice;
  double _discountAmount = 0;
  String? _appliedPromoCode;
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _originalPrice = widget.vehicle.pricePerDay * widget.rentalDuration;
    _totalPrice = _originalPrice;
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = await _profileService.getCurrentUserProfile();
      if (user != null) {
        setState(() {
          _currentUser = user;
          _nameController.text = user.name;
          _phoneController.text = user.phoneNumber;
          _emailController.text = user.email;
          _addressController.text = user.address ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat profil: $e')),
      );
    }
  }

  void _applyPromoCode() {
    final promoCode = _promoCodeController.text.trim().toUpperCase();
    final promos = {
      'NEWWEEK50': PromoModel(
        title: 'Diskon 50%',
        description: 'Untuk semua kendaraan',
        code: 'NEWWEEK50',
        discount: 0.5,
        validUntil: DateTime.now().add(const Duration(days: 7)),
      ),
      'NEWYEAR100': PromoModel(
        title: 'Diskon Rp 100.000',
        description: 'Potongan harga',
        code: 'NEWYEAR100',
        discount: 100000,
        validUntil: DateTime.now().add(const Duration(days: 30)),
      ),
    };

    final promo = promos[promoCode];

    if (promo != null && promo.validUntil.isAfter(DateTime.now())) {
      setState(() {
        _appliedPromoCode = promoCode;
        if (promo.discount is double) {
          _discountAmount = _originalPrice * promo.discount;
        } else {
          _discountAmount = (promo.discount as num).toDouble();
        }
        _discountAmount = _discountAmount > _originalPrice
          ? _originalPrice
          : _discountAmount;
        _totalPrice = _originalPrice - _discountAmount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo $promoCode berhasil diterapkan!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _appliedPromoCode = null;
        _discountAmount = 0;
        _totalPrice = _originalPrice;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode promo tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        final booking = BookingModel(
          id: '',
          userId: _currentUser?.id ?? '',
          vehicleId: widget.vehicle.id,
          vehicleName: widget.vehicle.name,
          vehicleBrand: widget.vehicle.brand,
          startDate: _startDate,
          endDate: _endDate,
          rentalDuration: widget.rentalDuration,
          totalPrice: _totalPrice,
          paymentMethod: _selectedPaymentMethod!,
          createdAt: DateTime.now(),
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Konfirmasi Booking'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Booking'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.local_offer),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PromoScreen()),
              );
            },
          ),
        ],
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[400],
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
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                const SizedBox(height: 16),
                const Text(
                  'Kode Promo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _promoCodeController,
                        decoration: InputDecoration(
                          labelText: 'Masukkan Kode Promo',
                          labelStyle: const TextStyle(color: Colors.black),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          suffixIcon: _appliedPromoCode != null
                            ?  Icon(Icons.check_circle, color: Colors.blue[400])
                            : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _applyPromoCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Terapkan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_appliedPromoCode != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Promo $_appliedPromoCode diterapkan',
                    style:  TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Harga Awal'),
                            Text('Rp ${NumberFormat('#,###').format(_originalPrice)}'),
                          ],
                        ),
                        if (_discountAmount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Diskon',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '- Rp ${NumberFormat('#,###').format(_discountAmount)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Harga',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[400],
                              ),
                            ),
                            Text(
                              'Rp ${NumberFormat('#,###').format(_totalPrice)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
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
    _promoCodeController.dispose();
    super.dispose();
  }
}
