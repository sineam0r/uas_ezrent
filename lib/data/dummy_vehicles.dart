import 'package:uas_ezrent/models/vehicle.dart';

class DummyVehicles {
  static List<VehicleModel> popularVehicles = [
    VehicleModel(
      id: '1',
      name: 'Avanza',
      type: 'Mobil',
      brand: 'Toyota',
      pricePerDay: 350000,
      imageUrl: 'assets/images/avanza.jpg',
      year: 2022,
      transmission: 'Manual',
      isAvailable: true,
    ),
    VehicleModel(
      id: '2',
      name: 'PCX',
      type: 'Motor',
      brand: 'Honda',
      pricePerDay: 150000,
      imageUrl: 'assets/images/pcx.jpg',
      year: 2023,
      transmission: 'Matic',
      isAvailable: true,
    ),
    VehicleModel(
      id: '3',
      name: 'Nmax',
      type: 'Motor',
      brand: 'Yamaha',
      pricePerDay: 120000,
      imageUrl: 'assets/images/nmax.jpg',
      year: 2021,
      transmission: 'Matic',
      isAvailable: true,
    ),
    VehicleModel(
      id: '4',
      name: 'Xpander',
      type: 'Mobil',
      brand: 'Mitsubishi',
      pricePerDay: 500000,
      imageUrl: 'assets/images/xpander.jpg',
      year: 2023,
      transmission: 'Manual',
      isAvailable: true,
    ),
  ];

  static List<VehicleModel> getVehiclesByCategory(String category) {
    if (category == 'Semua') {
      return popularVehicles;
    }
    return popularVehicles.where((vehicle) => vehicle.type == category).toList();
  }
}