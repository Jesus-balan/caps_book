import 'package:caps_book/features/config/styles.dart';
import 'package:flutter/material.dart';

class CustomBottomSheetButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget bottomSheet;

  const CustomBottomSheetButton({
    super.key,
    required this.label,
    required this.icon,
    required this.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          barrierColor: Colors.black.withOpacity(0.3),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => bottomSheet,
        );
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: ColorStyle.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
