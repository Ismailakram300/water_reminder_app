
import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(''),
      fit: BoxFit.fill),
    ),

    ),
  }
}
