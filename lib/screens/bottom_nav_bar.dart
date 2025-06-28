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
        selectedLabelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        onTap: (index){
          setState(() {
            _currentindex=index;
          });
        },
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color:Colors.white,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings,color: Colors.white,), label: 'setting'),
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.white,), label: 'home'),
        ],
      ),
    );
  }
}
