import 'package:caps_book/features/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

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
      child: DropdownButtonFormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        value: value,
        borderRadius: BorderRadius.circular(20),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.lora(fontSize: 16, color: ColorStyle.primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        style: GoogleFonts.lora(fontSize: 16, color: Colors.black),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: validator,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade800),
      ),
    );
  }
}
