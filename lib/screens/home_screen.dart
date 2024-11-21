import 'package:flutter/material.dart';
import 'package:uas_ezrent/data/dummy_data.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/screens/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  List<Vehicle> _filteredVehicles = [];
  bool _isListView = false;

  @override
  void initState() {
    super.initState();
    _filteredVehicles = dummyVehicles;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterVehicles();
  }

  void _filterVehicles() {
    setState(() {
      _filteredVehicles = dummyVehicles.where((vehicle) {
        if (_selectedCategory != 'Semua' && vehicle.type != _selectedCategory) {
          return false;
        }
        if (_searchController.text.isEmpty) {
          return true;
        }
        final searchTerm = _searchController.text.toLowerCase();
        return vehicle.nama.toLowerCase().contains(searchTerm) ||
              vehicle.brand.toLowerCase().contains(searchTerm) ||
              vehicle.type.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EZRent'),
        actions: [
          // Toggle View Button
          IconButton(
            icon: Icon(_isListView ? Icons.grid_view : Icons.view_list),
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
          ),
          // Tambahkan filter harga
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (String result) {
              setState(() {
                switch (result) {
                  case 'Termurah':
                    _filteredVehicles.sort((a, b) => a.tarif.compareTo(b.tarif));
                    break;
                  case 'Termahal':
                    _filteredVehicles.sort((a, b) => b.tarif.compareTo(a.tarif));
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Termurah',
                child: Text('Harga Termurah'),
              ),
              const PopupMenuItem<String>(
                value: 'Termahal',
                child: Text('Harga Termahal'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mau sewa kendaraan apa?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari kendaraan...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      filled: true,
                    )
                  )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryItem(
                          icon: Icons.category,
                          label: 'Semua',
                          isSelected: _selectedCategory == 'Semua',
                        ),
                        const SizedBox(width: 12),
                        _buildCategoryItem(
                          icon: Icons.car_rental,
                          label: 'Mobil',
                          isSelected: _selectedCategory == 'Mobil',
                        ),
                        const SizedBox(width: 12),
                        _buildCategoryItem(
                          icon: Icons.two_wheeler,
                          label: 'Motor',
                          isSelected: _selectedCategory == 'Motor',
                        ),
                        const SizedBox(width: 12),
                        _buildCategoryItem(
                          icon: Icons.electric_bike,
                          label: 'Sepeda',
                          isSelected: _selectedCategory == 'Sepeda',
                        ),
                        const SizedBox(width: 12),
                        _buildCategoryItem(
                          icon: Icons.local_shipping,
                          label: 'Pick Up',
                          isSelected: _selectedCategory == 'Pick Up',
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory == 'Semua'
                          ? 'Kendaraan Tersedia'
                          : 'Kendaraan $_selectedCategory',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      if (_filteredVehicles.length != dummyVehicles.length)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'Semua';
                              _searchController.clear();
                            });
                            _filterVehicles();
                          },
                          child: const Text('Reset Filter')
                        )
                    ]
                  ),
                  const SizedBox(height: 12.0),
                  _filteredVehicles.isEmpty
                    ? _buildEmptyState()
                    : _buildAvailableVehicleList()
                ]
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildPromoCard(
                    'Diskon 10%',
                    'Untuk pemesanan mobil di hari kerja',
                    Colors.blue,
                  ),
                  _buildPromoCard(
                    'Gratis 1 Hari',
                    'Untuk pemesanan minimal 7 hari',
                    Colors.orange,
                  ),
                  _buildPromoCard(
                    'Cashback 5%',
                    'Untuk pembayaran via transfer bank',
                    Colors.green,
                  ),
                ]
              ),
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

  Widget _buildAvailableVehicleList() {
    return _isListView 
      ? GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _filteredVehicles.length,
          itemBuilder: (context, index) => _buildVehicleCard(context, _filteredVehicles[index]),
        )
      : SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filteredVehicles.length,
            itemBuilder: (context, index) => _buildHorizontalVehicleCard(context, _filteredVehicles[index]),
          ),
        );
  }

  // Kartu kendaraan untuk tampilan grid
  Widget _buildVehicleCard(BuildContext context, Vehicle vehicle) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context, vehicle),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: AssetImage(vehicle.imageUrl),
                    fit: BoxFit.cover
                  )
                ),
                child: _buildAvailabilityTag(vehicle),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildVehicleDetails(vehicle),
              )
            )
          ],
        ),
      ),
    );
  }

  // Kartu kendaraan untuk tampilan horizontal
  Widget _buildHorizontalVehicleCard(BuildContext context, Vehicle vehicle) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => _navigateToDetails(context, vehicle),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage(vehicle.imageUrl),
                      fit: BoxFit.cover
                    )
                  ),
                  child: _buildAvailabilityTag(vehicle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildVehicleDetails(vehicle),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Tag ketersediaan kendaraan
  Widget _buildAvailabilityTag(Vehicle vehicle) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4
        ),
        decoration: BoxDecoration(
          color: vehicle.isAvailable
            ? Colors.green
            : Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          vehicle.isAvailable ? 'Tersedia' : 'Disewa',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Detail kendaraan
  Widget _buildVehicleDetails(Vehicle vehicle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${vehicle.brand} ${vehicle.nama}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              vehicle.type == 'Mobil'
                ? Icons.car_rental
                : Icons.motorcycle,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              vehicle.transmisi,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Rp ${vehicle.tarif.toStringAsFixed(0)}/hari',
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        )
      ],
    );
  }

  // Navigasi ke halaman detail
  void _navigateToDetails(BuildContext context, Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(vehicle: vehicle),
      )
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada kendaraan yang ditemukan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ubah kata kunci atau filter kategori',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _onCategorySelected(label),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.blue[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(String title, String description, Color color) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      )
    );
  }
}