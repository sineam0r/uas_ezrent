import 'package:flutter/material.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/screens/vehicle_detail_screen.dart';
import 'package:uas_ezrent/data/dummy_vehicles.dart';
import 'package:uas_ezrent/widgets/home/vehicle_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  List<VehicleModel> _allVehicles = [];
  List<VehicleModel> _filteredVehicles = [];

  String _selectedCategory = 'Semua';
  String _selectedTransmission = 'Semua';
  bool _isAvailableOnly = false;

  final List<String> _categories = ['Semua', 'Motor', 'Mobil', 'Sepeda'];
  final List<String> _transmissionTypes = ['Semua', 'Manual', 'Matic'];

  @override
  void initState() {
    super.initState();
    _allVehicles = DummyVehicles.popularVehicles;
    _filteredVehicles = _allVehicles;
  }

  void _applyFilters() {
    setState(() {
      _filteredVehicles = _allVehicles.where((vehicle) {
        bool textMatch = _searchController.text.isEmpty ||
            vehicle.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            vehicle.category.toLowerCase().contains(_searchController.text.toLowerCase());

        bool categoryMatch = _selectedCategory == 'Semua' ||
          vehicle.type.toLowerCase() == _selectedCategory.toLowerCase();

        bool transmissionMatch = _selectedTransmission == 'Semua' ||
            vehicle.transmission.toLowerCase() == _selectedTransmission.toLowerCase();

        bool priceMatch = true;
        if (_minPriceController.text.isNotEmpty) {
          double minPrice = double.tryParse(_minPriceController.text) ?? 0;
          priceMatch = priceMatch && vehicle.pricePerDay >= minPrice;
        }
        if (_maxPriceController.text.isNotEmpty) {
          double maxPrice = double.tryParse(_maxPriceController.text) ?? double.infinity;
          priceMatch = priceMatch && vehicle.pricePerDay <= maxPrice;
        }

        bool availabilityMatch = !_isAvailableOnly || vehicle.isAvailable;

        return textMatch && categoryMatch && transmissionMatch && priceMatch && availabilityMatch;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedCategory = 'Semua';
      _selectedTransmission = 'Semua';
      _isAvailableOnly = false;
      _applyFilters();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Filter Lanjutan',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _selectedTransmission,
                    decoration: const InputDecoration(
                      labelText: 'Transmisi',
                      border: OutlineInputBorder(),
                    ),
                    items: _transmissionTypes.map((transmission) {
                      return DropdownMenuItem(
                        value: transmission,
                        child: Text(transmission),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedTransmission = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minPriceController,
                          decoration: const InputDecoration(
                            labelText: 'Harga Min',
                            border: OutlineInputBorder(),
                            prefixText: 'Rp ',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _maxPriceController,
                          decoration: const InputDecoration(
                            labelText: 'Harga Max',
                            border: OutlineInputBorder(),
                            prefixText: 'Rp ',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SwitchListTile(
                    title: const Text('Hanya Kendaraan Tersedia'),
                    value: _isAvailableOnly,
                    onChanged: (bool value) {
                      setModalState(() {
                        _isAvailableOnly = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      _resetFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Reset Filter'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _applyFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Terapkan Filter'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Kendaraan'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kendaraan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _applyFilters();
              },
            ),
          ),
          Expanded(
            child: _filteredVehicles.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada kendaraan ditemukan',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _filteredVehicles.length,
                  itemBuilder: (context, index) {
                    return VehicleCard(
                      vehicle: _filteredVehicles[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailScreen(
                              vehicle: _filteredVehicles[index],
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
}
