import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/user.dart';
import 'package:uas_ezrent/screens/auth/login_screen.dart';
import 'package:uas_ezrent/services/auth_service.dart';
import 'package:uas_ezrent/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    final user = await _profileService.getCurrentUserProfile();

    if (user != null) {
      setState(() {
        _currentUser = user;
        _nameController.text = user.name;
        _phoneController.text = user.phoneNumber;
        _addressController.text = user.address ?? '';
        _selectedBirthDate = user.birthDate;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final success = await _profileService.updateProfile(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        birthDate: _selectedBirthDate,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        _loadUserProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui profil')),
        );
      }
    }
  }

  void _logout() {
    _authService.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                      value!.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectBirthDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Lahir',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _selectedBirthDate != null
                          ? DateFormat('dd MMMM yyyy').format(_selectedBirthDate!)
                          : 'Pilih Tanggal Lahir',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Perbarui Profil'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email: ${_currentUser?.email ?? ""}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Bergabung sejak: ${_currentUser != null 
                      ? DateFormat('dd MMMM yyyy').format(_currentUser!.createdAt)
                      : ""}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}