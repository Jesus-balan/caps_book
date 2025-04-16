import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonDropdownField<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CommonDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        value: value,
        hint: Text('Select $label'),
        borderRadius: BorderRadius.circular(20),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.lora(fontSize: 16, color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        style: GoogleFonts.lora(fontSize: 16, color: Colors.black),
        items: items,
        onChanged: onChanged,
        validator: validator,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade800),
      ),
    );
  }
}
