import 'package:flutter/material.dart';

class IncentiveScreen extends StatelessWidget {
  const IncentiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home')),
      body: const Center(child: Text('Welcome to Caps Booking App')),
    );
  }
}
