import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatelessWidget {
  final BuildContext context;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DateInputField({
    super.key,
    required this.context,
    this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueAccent,
            hintColor: Colors.blueAccent,
            colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _selectBirthDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Tanggal Lahir',
          labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
        child: Text(
          selectedDate != null
            ? DateFormat('dd MMMM yyyy').format(selectedDate!)
            : 'Pilih Tanggal Lahir',
          style: GoogleFonts.poppins(
            color: selectedDate != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}