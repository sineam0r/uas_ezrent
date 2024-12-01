import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const BookingInputField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
          prefixIcon: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
          suffixIcon: suffixIcon,
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
      ),
    );
  }
}