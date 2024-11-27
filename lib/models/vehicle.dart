class VehicleModel {
  final String id;
  final String name;
  final String type;
  final String brand;
  final double pricePerDay;
  final String imageUrl;
  final int year;
  final String transmission;
  final bool isAvailable;

  VehicleModel({
    required this.id,
    required this.name,
    required this.type,
    required this.brand,
    required this.pricePerDay,
    required this.imageUrl,
    required this.year,
    required this.transmission,
    required this.isAvailable,
  });

  factory VehicleModel.fromFirestore(Map<String, dynamic> firestore) {
    return VehicleModel(
      id: firestore['id'],
      name: firestore['name'],
      type: firestore['type'],
      brand: firestore['brand'],
      pricePerDay: firestore['pricePerDay'],
      imageUrl: firestore['imageUrl'],
      year: firestore['year'],
      transmission: firestore['transmission'],
      isAvailable: firestore['isAvailable'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'brand': brand,
      'pricePerDay': pricePerDay,
      'imageUrl': imageUrl,
      'year': year,
      'transmission': transmission,
      'isAvailable': isAvailable,
    };
  }
}