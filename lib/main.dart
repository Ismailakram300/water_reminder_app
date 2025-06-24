import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_reminder_app/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  //  statusBarIconBrightness: Brightness.dark,
  ));


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Reminder App',
      home: SplashScreen(),
    );
  }
}