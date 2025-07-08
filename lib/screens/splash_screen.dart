import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder_app/screens/home_screen.dart';

import '../Database/database_helper.dart';
import '../customs_widgets/mytext.dart';
import 'bottom_nav_bar.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Future<void> _checkSession() async {
     // Optional: splash delay
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedOnboarding = prefs.getBool('onboardingComplete') ?? false;
    print(hasCompletedOnboarding);

    if (hasCompletedOnboarding) {
    //  await DatabaseHelper.instance.deleteDatabaseFile();
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    } else {
    //  final db = await DatabaseHelper.instance.database;
//await db.execute('ALTER TABLE user_data ADD COLUMN selectedMl INTEGER');
      //await DatabaseHelper.instance.deleteDatabaseFile();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }
  @override
  void initState() {
    // //TODO: implement initState
    // Timer(Duration(seconds: 4), () async{
    //
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   bool seen= prefs.getBool('_isonboardingComplete')?? false;
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => OnboardingScreen()),
    //   );
    // });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffDDECF8),
          image: DecorationImage(
            image: AssetImage("assets/images/sp_img.png"),
            fit: BoxFit.fill,
          ),
        ),
      
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200,),

              Image(image: AssetImage("assets/images/water.png")),
              SizedBox(height: 10,),
              Mytext(txt: "Water Reminder",),
              SizedBox(height: 150,),
              InkWell(
                onTap: _checkSession,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff278DE8),
                  ),
                  width: 180,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Mytext(

                        txt: "Let's Start",
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 14,),
                      Icon(Icons.arrow_forward,color: Colors.white,),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
