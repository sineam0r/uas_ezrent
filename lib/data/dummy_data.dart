import 'package:uas_ezrent/models/vehicle.dart';

final List<Vehicle> dummyVehicles = [
  Vehicle(
    id: '1',
    nama: 'Avanza',
    brand: 'Toyota',
    imageUrl: 'assets/images/avanza.jpg',
    tarif: 300000,
    type: 'Mobil',
    deskripsi: 'Toyota Avanza 2022 dengan kondisi sangat baik',
    transmisi: 'Manual',
    kapasitas: 6
  ),
  Vehicle(
    id: '2',
    nama: 'Xpander',
    brand: 'Mitsubishi',
    imageUrl: 'assets/images/xpander.jpg',
    tarif: 350000,
    type: 'Mobil',
    deskripsi: 'Mitsubishi Xpander Ultimate 2023',
    transmisi: 'Automatic',
    kapasitas: 7
  ),
  Vehicle(
    id: '3',
    nama: 'PCX',
    brand: 'Honda',
    imageUrl: 'assets/images/pcx.jpg',
    tarif: 150000,
    type: 'Motor',
    deskripsi: 'Honda PCX 160cc 2023',
    transmisi: 'Automatic',
    kapasitas: 2
  ),
  Vehicle(
    id: '4',
    nama: 'Nmax',
    brand: 'Yamaha',
    imageUrl: 'assets/images/nmax.jpg',
    tarif: 150000,
    type: 'Motor',
    deskripsi: 'Yamaha Nmax 155cc 2023',
    transmisi: 'Automatic',
    kapasitas: 2
  ),
];