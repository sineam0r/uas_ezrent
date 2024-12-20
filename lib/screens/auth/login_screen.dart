import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/screens/auth/register_screen.dart';
import 'package:uas_ezrent/screens/auth/reset_password_screen.dart';
import 'package:uas_ezrent/screens/home_screen.dart';
import 'package:uas_ezrent/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _showPassword = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final result = await _authService.login(
      context: context,
      email: _emailController.text,
      password: _passwordController.text
    );

    if (result['success']) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 1),
                Column(
                  children: [
                    Image.asset(
                      'assets/logo/EZRentSD.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Sewa Kendaraan Jadi Lebih Mudah',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                            prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                            prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: !_showPassword,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: Text(
                              'Reset Password',
                              style: GoogleFonts.poppins(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                                  strokeWidth: 3,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'Login',
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
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Belum punya akun? ',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Daftar',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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