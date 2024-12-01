import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/screens/favorite_screen.dart';
import 'package:uas_ezrent/screens/history_screen.dart';
import 'package:uas_ezrent/screens/notification_screen.dart';
import 'package:uas_ezrent/screens/profile_screen.dart';
import 'package:uas_ezrent/screens/promo_screen.dart';
import 'package:uas_ezrent/screens/search_screen.dart';
import 'package:uas_ezrent/screens/vehicle_detail_screen.dart';
import 'package:uas_ezrent/widgets/home/vehicle_card.dart';
import 'package:uas_ezrent/data/dummy_vehicles.dart';
import 'package:uas_ezrent/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<VehicleModel> _displayedVehicles = [];
  int _currentIndex = 0;
  bool _hasUnreadNotifications = false;

  late List<Widget> _screens;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _displayedVehicles = DummyVehicles.popularVehicles;

    _screens = [
      _buildBody(),
      const FavoriteScreen(),
      HistoryScreen(),
    ];

    _notificationService.getUserNotifications().listen((notifications) {
      setState(() {
        _hasUnreadNotifications = notifications.any((notification) =>
          notification.isRead == false);
      });
    });
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Kendaraan Populer',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'EZRent',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationScreen()),
                  );
                },
              ),
              if (_hasUnreadNotifications)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blueAccent),
              title: Text(
                'Profil',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.blueAccent),
              title: Text(
                'Promo',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PromoScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
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
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}