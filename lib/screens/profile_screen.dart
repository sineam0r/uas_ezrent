import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/user.dart';
import 'package:uas_ezrent/screens/auth/login_screen.dart';
import 'package:uas_ezrent/services/auth_service.dart';
import 'package:uas_ezrent/services/profile_service.dart';
import 'package:uas_ezrent/widgets/profile/custom_text_field.dart';
import 'package:uas_ezrent/widgets/profile/date_input_field.dart';

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
          SnackBar(
            content: Text(
              'Profil berhasil diperbarui',
              style: GoogleFonts.poppins(),
            ),
          ),
        );
        _loadUserProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memperbarui profil',
              style: GoogleFonts.poppins(),
            ),
          ),
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text(
          'Profilku',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black,),
            onPressed: _logout,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                strokeWidth: 3,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    'Edit Profil',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                CustomTextField(
                                  controller: _nameController,
                                  label: 'Nama Lengkap',
                                  icon: Icons.person,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _phoneController,
                                  label: 'Nomor Telepon',
                                  icon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _addressController,
                                  label: 'Alamat',
                                  icon: Icons.location_on,
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 16),
                                DateInputField(
                                  context: context,
                                  selectedDate: _selectedBirthDate,
                                  onDateSelected: (date) {
                                    setState(() {
                                      _selectedBirthDate = date;
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: _updateProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    minimumSize: const Size(double.infinity, 52),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: Text(
                                    'Perbarui Profil',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Email: ${_currentUser?.email ?? ""}',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Bergabung sejak: ${_currentUser?.createdAt == null ? "" : DateFormat("dd MMMM yyyy").format(_currentUser!.createdAt)}',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

