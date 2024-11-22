import 'package:flutter/material.dart';
import 'package:uas_ezrent/data/dummy_data.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/screens/details_screen.dart';
import 'package:uas_ezrent/screens/history_screen.dart';
import 'package:uas_ezrent/screens/home_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Vehicle> _favoriteVehicles = [];

  int _selectedIndex = 1;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => _screens[index],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _favoriteVehicles = dummyVehicles.where((vehicle) => vehicle.isFavorite).toList();
  }

  void _toggleFavorite(Vehicle vehicle) {
    setState(() {
      vehicle.isFavorite = !vehicle.isFavorite;
      _favoriteVehicles = dummyVehicles.where((v) => v.isFavorite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Kendaraan'),
      ),
      body: _favoriteVehicles.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _favoriteVehicles.length,
            itemBuilder: (context, index) {
              final vehicle = _favoriteVehicles[index];
              return _buildFavoriteItem(vehicle);
            },
        ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(Vehicle vehicle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Image.asset(
          vehicle.imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        title: Text(
          '${vehicle.brand} ${vehicle.nama}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Rp ${vehicle.tarif.toStringAsFixed(0)}/hari',
          style: TextStyle(
            color: Colors.blue[700],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () => _toggleFavorite(vehicle),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(vehicle: vehicle),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada kendaraan favorit',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan kendaraan ke favorit dari halaman detail',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}