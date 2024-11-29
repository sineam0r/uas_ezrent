import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String vehicleId;
  final String vehicleName;
  final String vehicleBrand;
  final DateTime startDate;
  final DateTime endDate;
  final int rentalDuration;
  final double totalPrice;
  final String paymentMethod;
  final String status;

  BookingModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleBrand,
    required this.startDate,
    required this.endDate,
    required this.rentalDuration,
    required this.totalPrice,
    required this.paymentMethod,
    this.status = 'pending',
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BookingModel(
      id: documentId,
      userId: map['userId'],
      vehicleId: map['vehicleId'],
      vehicleName: map['vehicleName'],
      vehicleBrand: map['vehicleBrand'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      rentalDuration: map['rentalDuration'],
      totalPrice: map['totalPrice'],
      paymentMethod: map['paymentMethod'],
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'vehicleBrand': vehicleBrand,
      'startDate': startDate,
      'endDate': endDate,
      'rentalDuration': rentalDuration,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }
}