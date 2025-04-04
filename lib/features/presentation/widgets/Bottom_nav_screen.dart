import 'package:caps_book/features/presentation/ui/home/attendance_screen.dart';
import 'package:caps_book/features/presentation/ui/home/betta_screen.dart';
import 'package:caps_book/features/presentation/ui/home/home_screen.dart';
import 'package:caps_book/features/presentation/ui/home/profile_screen.dart';
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
    OrderScreen(),
    ProfileScreen(),
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
          FluidNavBarIcon(icon: Icons.shopping_cart),
          FluidNavBarIcon(icon: Icons.person),
        ],
        onChange: _onItemTapped,
        style: FluidNavBarStyle(
          barBackgroundColor: Colors.grey[200],
          iconUnselectedForegroundColor: Colors.black,
          iconSelectedForegroundColor: Color.fromARGB(255, 13, 71, 161),
        ),
      ),
    );
  }
}