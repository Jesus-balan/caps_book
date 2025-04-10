import 'package:caps_book/features/config/styles.dart';
import 'package:flutter/material.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: ColorStyle.primaryColor,
      body: Column(
        children: [
          // Top Car Image
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: -width * 0.7,
                  child: Image.asset(
                    'assets/images/car-img.png',
                    width: width * 1.7,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          // Text & Button Section
          Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Drive & Earn.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "Be your own boss",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: height * 0.015),
                Text(
                  "Join our platform, accept rides with ease, track earnings, and drive on your schedule. Start earning today!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: width * 0.035,
                  ),
                ),
                SizedBox(height: height * 0.04),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
