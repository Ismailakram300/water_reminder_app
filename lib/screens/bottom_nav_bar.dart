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
        backgroundColor: Color(0xff278DE8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xffD4D4D4),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Mulish',
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Mulish',
          fontWeight: FontWeight.normal,
          fontSize: 13,
        ),
        currentIndex: _currentindex, // ✅ Fix current index here
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined,), label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined,), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.settings,), label: 'Settings'),
        ],
      ),
    );
  }
}
