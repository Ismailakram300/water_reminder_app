import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder_app/screens/home_screen.dart';

import 'analysis.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentindex = 0;
  List screenList = [HomeScreen(), Analysis()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'setting'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        ],
      ),
    );
  }
}
