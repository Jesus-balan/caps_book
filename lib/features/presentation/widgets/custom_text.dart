import 'package:flutter/material.dart';

// Reusable Text Widget
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight ?? FontWeight.normal, color: color ?? Colors.black),
    );
  }
}
