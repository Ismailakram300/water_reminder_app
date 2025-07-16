import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/bottom_nav_bar.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const MyAppBar({super.key, required this.title});
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // typically 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff278DE8),
      automaticallyImplyLeading: false, // Since we're manually adding the back button
      elevation: 0,
      titleSpacing: 0, // 👈 removes default spacing from the left
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()),
              );
            },
          ),
          Text(
            'Analytics',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Mulish',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

  }
}
