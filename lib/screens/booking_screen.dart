import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/promo.dart';
import 'package:uas_ezrent/models/user.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/screens/promo_screen.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/services/profile_service.dart';
import 'package:uas_ezrent/screens/confirmation_screen.dart';
import 'package:uas_ezrent/widgets/booking/booking_form_section.dart';
import 'package:uas_ezrent/widgets/booking/booking_input_field.dart';
import 'package:uas_ezrent/widgets/booking/booking_price_summary.dart';
import 'package:uas_ezrent/widgets/booking/booking_veicle_details.dart';

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
  bool _isSubmitting = false;

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
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e', style: GoogleFonts.poppins())),
        );
      }
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

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
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
          userName: _nameController.text,
          userPhone: _phoneController.text,
          userEmail: _emailController.text,
          userAddress: _addressController.text,
        );

        final bookingId = await _bookingService.addBooking(booking);

        if (mounted) {
          Navigator.push(
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
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal membuat booking: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          title: Text(
            'Konfirmasi Booking',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
            strokeWidth: 3,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text(
          'Konfirmasi Booking',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_offer, color: Colors.black,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PromoScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BookingVehicleDetails(
                  vehicle: widget.vehicle,
                  startDate: _startDate,
                  endDate: _endDate,
                ),
                const SizedBox(height: 24),
                BookingFormSection(
                  title: 'Informasi Penyewa',
                  children: [
                    BookingInputField(
                      controller: _nameController,
                      label: 'Nama Lengkap',
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? 'Mohon masukkan nama lengkap' : null,
                    ),
                    const SizedBox(height: 12),
                    BookingInputField(
                      controller: _phoneController,
                      label: 'Nomor Telepon',
                      icon: Icons.phone,
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
                    const SizedBox(height: 12),
                    BookingInputField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    BookingInputField(
                      controller: _addressController,
                      label: 'Alamat',
                      icon: Icons.location_on,
                      maxLines: 3,
                      validator: (value) =>
                          value!.isEmpty ? 'Mohon masukkan alamat lengkap' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                BookingFormSection(
                  title: 'Metode Pembayaran',
                  children: [
                    Card(
                      elevation: 0,
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          width: 1,
                          color: Colors.grey[300]!,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<String>(
                          value: _selectedPaymentMethod,
                          items: _paymentMethods.map((method) {
                            return DropdownMenuItem<String>(
                              value: method,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  method,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          },
                          validator: (value) => value == null ? 'Mohon pilih metode pembayaran' : null,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.payment, color: Colors.blueAccent),
                            hintText: 'Pilih metode pembayaran',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            alignLabelWithHint: true,
                          ),
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          alignment: AlignmentDirectional.centerStart,
                        ),
                      ),
                    ),
                  ],
                ),
                BookingFormSection(
                  title: 'Kode Promo',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: BookingInputField(
                            controller: _promoCodeController,
                            label: 'Masukkan Kode Promo',
                            suffixIcon: _appliedPromoCode != null
                                ? const Icon(Icons.check_circle,
                                    color: Colors.blueAccent)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _applyPromoCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Terapkan',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_appliedPromoCode != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Promo $_appliedPromoCode diterapkan',
                        style: GoogleFonts.poppins(
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                BookingPriceSummary(
                  originalPrice: _originalPrice,
                  discountAmount: _discountAmount,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text(
                            'Konfirmasi dan Bayar',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
}


