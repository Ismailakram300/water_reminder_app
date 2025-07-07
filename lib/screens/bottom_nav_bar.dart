import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder_app/screens/home_screen.dart';
import 'package:water_reminder_app/screens/settings.dart';

import 'analysis.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentindex = 0;
  List screenList = [HomeScreen(), Analysis(),SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xffD4D4D4),
        selectedLabelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          color: Color(0xffD4D4D4),
          fontSize: 12,
        ),
        currentIndex: _currentindex, // ✅ Fix current index here
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color:Colors.white,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined,color: Colors.white,), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.settings,color: Colors.white,), label: 'Settings'),
        ],
      ),
    );
  }
}
