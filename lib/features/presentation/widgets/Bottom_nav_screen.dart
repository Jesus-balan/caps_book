import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/ui/home/attendance_screen.dart';
import 'package:caps_book/features/presentation/ui/home/myride_screen.dart';
import 'package:caps_book/features/presentation/ui/home/home_screen.dart';
import 'package:caps_book/features/presentation/ui/home/Incentive_screen.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0; // Maintain selected index
  final List<Widget> _pages = [
    HomeScreen(),
    AttendanceScreen(),
    MyRideScreen(),
    IncentiveScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show selected page
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(icon: Icons.home),
          FluidNavBarIcon(icon: Icons.calendar_month),
          FluidNavBarIcon(icon: Icons.local_taxi),
          FluidNavBarIcon(icon: Icons.card_giftcard),
        ],
        onChange: _onItemTapped,
        style: FluidNavBarStyle(
          barBackgroundColor: ColorStyle.primaryColor,
          iconUnselectedForegroundColor: Colors.white,
          iconSelectedForegroundColor: Colors.white,
        ),
      ),
    );
  }
}