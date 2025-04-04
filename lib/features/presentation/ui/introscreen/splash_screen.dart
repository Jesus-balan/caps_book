import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, "/getStart");
    });

    return Scaffold(
      backgroundColor: Colors.black, // Dark theme for a clean look
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/cabs.png", width: 150, color: Colors.yellow,), // Your App Logo
            const SizedBox(height: 20),
            DefaultTextStyle(
              style: GoogleFonts.lora(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Zenvic Cabs', // Change text here
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1, // Play only once
              ),
            ),
          ],
        ),
      ),
    );
  }
}
