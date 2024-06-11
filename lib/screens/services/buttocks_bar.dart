import 'package:flutter/material.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:petlv/screens/favorite_screen.dart'; // Add your favorite screen import
import 'package:petlv/screens/services/buttocks_service.dart';
import '../missing/missing_screen.dart';
import '../notification/notification_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    FavoriteScreen(), // Add your favorite screen here
    MissingScreen(), // Add your missing screen here
    NotificationScreen(), // Add your notification screen here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}




