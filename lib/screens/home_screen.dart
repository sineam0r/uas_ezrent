import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/widgets/category_filter.dart';
import 'package:uas_ezrent/widgets/promo_card.dart';
import 'package:uas_ezrent/widgets/vehicle_card.dart';
import 'package:uas_ezrent/data/dummy_vehicles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'Semua',
    'Mobil',
    'Motor',
    'Sepeda',
  ];

  String _selectedCategory = 'Semua';
  List<VehicleModel> _displayedVehicles = [];

  @override
  void initState() {
    super.initState();
    _displayedVehicles = DummyVehicles.popularVehicles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rental Kendaraan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PromoCard(
                title: 'Diskon 50% Minggu Ini!',
                subtitle: 'Untuk semua kendaraan baru',
                onTap: () {
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Kategori Kendaraan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CategoryFilter(
              categories: categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                  _displayedVehicles = DummyVehicles.getVehiclesByCategory(category);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kendaraan Populer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/vehicle');
                    },
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _displayedVehicles.length,
              itemBuilder: (context, index) {
                return VehicleCard(
                  vehicle: _displayedVehicles[index],
                  onTap: () {
                    Navigator.pushNamed(
                      context, 
                      '/vehicle-detail', 
                      arguments: _displayedVehicles[index]
                    );
                  },
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/favorites');
              break;
            case 2:
              Navigator.pushNamed(context, '/history');
              break;
          }
        },
      ),
    );
  }
}