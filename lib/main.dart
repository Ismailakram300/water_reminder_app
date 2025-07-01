import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:water_reminder_app/screens/splash_screen.dart';

import 'Database/database_helper.dart';
import 'notification_service.dart';

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await requestNotificationPermission();


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.lightBlue,
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