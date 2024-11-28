import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/screens/favorite_screen.dart';
import 'package:uas_ezrent/screens/profile_screen.dart';
import 'package:uas_ezrent/screens/vehicle_detail_screen.dart';
import 'package:uas_ezrent/widgets/home/category_filter.dart';
import 'package:uas_ezrent/widgets/home/promo_card.dart';
import 'package:uas_ezrent/widgets/home/vehicle_card.dart';
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
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _displayedVehicles = DummyVehicles.popularVehicles;

    _screens = [
      _buildBody(),
      const FavoriteScreen(),
    ];
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PromoCard(
                    title: 'Diskon 50% Minggu Ini!',
                    subtitle: 'Untuk semua kendaraan baru',
                    onTap: () {},
                  ),
                  const SizedBox(width: 1),
                  PromoCard(
                    title: 'Promo Akhir Tahun',
                    subtitle: 'Hemat sampai Rp 100.000',
                    onTap: () {},
                  ),
                ],
              ),
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
                    // vehicle screen
                  },
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleDetailScreen(
                        vehicle: _displayedVehicles[index],
                      ),
                    ),
                  );
                },
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EZRent',
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
              // notifikasi
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // search
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80,
              color: Colors.blue,
              child: const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 32.0),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_offer),
              title: const Text('Promo'),
              onTap: () {
                Navigator.pop(context);
                // promo screen
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}