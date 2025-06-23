import 'dart:async';

import 'package:flutter/material.dart';

import '../customs_widgets/mytext.dart';
import 'home_screen.dart';
import 'onboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //TODO: implement initState
    Timer(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnboardingProgressHeader(currentStep: 0,)),
      );
    });
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
              Image(image: AssetImage("assets/images/water.png")),
              SizedBox(height: 10,),
              Mytext(txt: "Water Reminder",),
            ],
          ),
        ),
      ),
    );
  }
}
