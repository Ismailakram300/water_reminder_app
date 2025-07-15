import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/bottom_nav_bar.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const MyAppBar({super.key, required this.title});
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // typically 56.0

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      actions: [],
      //  backgroundColor: Color(0xff),
      backgroundColor: Color(0xff278DE8),
      automaticallyImplyLeading: false,

      // elevation: 0,
      title: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero, // 👈 removes default padding
            constraints: BoxConstraints(),
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (Context) => BottomNavBar()),
              ); // 👈 back to previous screen
            },
          ),
 // 👈 Add space after the back button
          Text(
            title,
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
