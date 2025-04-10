import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate after checking token
    Future.delayed(const Duration(seconds: 3), () async {
      final hiveService = HiveService();
      bool isLoggedIn = await hiveService.isLoggedIn();

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/bottombar');
      } else {
        Navigator.pushReplacementNamed(context, '/getStart');
      }
    });

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: ColorStyle.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/cabs.png",
                width: width * 0.4,
                color: Colors.white,
              ),
              SizedBox(height: height * 0.02),
              DefaultTextStyle(
                style: GoogleFonts.lora(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Zenvic Cabs',
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
