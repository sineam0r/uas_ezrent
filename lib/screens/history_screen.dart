import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/data/dummy_vehicles.dart';
import 'package:uas_ezrent/models/booking.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/screens/booking_detail_screen.dart';
import 'package:uas_ezrent/widgets/history/history_content.dart';
import 'package:uas_ezrent/widgets/history/history_empty_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final BookingService _bookingService = BookingService();
  late StreamSubscription<List<BookingModel>> _bookingsSubscription;
  List<BookingModel>? _bookings;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  @override
  void dispose() {
    _bookingsSubscription.cancel();
    super.dispose();
  }

  void _updateDummyVehicleAvailability(String vehicleId, bool isAvailable) {
    final vehicleIndex = DummyVehicles.popularVehicles.indexWhere((v) => v.id == vehicleId);
    if (vehicleIndex != -1) {
      final oldVehicle = DummyVehicles.popularVehicles[vehicleIndex];
      final newVehicle = VehicleModel(
        id: oldVehicle.id,
        name: oldVehicle.name,
        type: oldVehicle.type,
        brand: oldVehicle.brand,
        pricePerDay: oldVehicle.pricePerDay,
        imageUrl: oldVehicle.imageUrl,
        year: oldVehicle.year,
        transmission: oldVehicle.transmission,
        isAvailable: isAvailable,
      );
      DummyVehicles.popularVehicles[vehicleIndex] = newVehicle;
    }
  }

  Future<void> _handleBookingStatusChange(BookingModel booking) async {
    if (booking.status != 'finished' && booking.status != 'cancelled') {
      _updateDummyVehicleAvailability(booking.vehicleId, false);
    } else {
      _updateDummyVehicleAvailability(booking.vehicleId, true);
    }
  }

  Future<void> _fetchBookings() async {
    try {
      _bookingsSubscription = _bookingService.getUserBookings().listen(
        (bookings) {
          for (var booking in bookings) {
            _handleBookingStatusChange(booking);
          }

          setState(() {
            _bookings = bookings;
            _isLoading = false;
            _errorMessage = null;
          });
        },
        onError: (error) {
          setState(() {
            _bookings = null;
            _isLoading = false;
            _errorMessage = 'Error loading bookings: $error';
          });
        },
      );
    } catch (e) {
      setState(() {
        _bookings = null;
        _isLoading = false;
        _errorMessage = 'Error loading bookings: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Riwayat Rentalku',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: const HistoryEmptyState(isLoggedIn: false),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Riwayat Rentalku',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: HistoryContent(
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          bookings: _bookings,
          onDelete: (booking) async {
            try {
              await _bookingService.deleteBooking(booking.id);
              _updateDummyVehicleAvailability(booking.vehicleId, true);
              setState(() {
                _bookings!.remove(booking);
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error deleting booking: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          onBookingTap: (booking) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingDetailScreen(booking: booking),
              ),
            );
          },
        ),
      ),
    );
  }
}