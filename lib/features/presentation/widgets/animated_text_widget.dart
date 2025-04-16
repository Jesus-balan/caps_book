import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedDotsText extends StatefulWidget {
  final String text;
  const AnimatedDotsText({super.key, required this.text});

  @override
  State<AnimatedDotsText> createState() => _AnimatedDotsTextState();
}

class _AnimatedDotsTextState extends State<AnimatedDotsText> {
  int dotCount = 1;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount % 3) + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${widget.text}${"." * dotCount}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.teal,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
