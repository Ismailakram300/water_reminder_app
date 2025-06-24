import 'package:flutter/cupertino.dart';

class Mytext extends StatelessWidget {
  final String txt;
  final double size;
  final TextDecoration decoration;
  final Color color;

  Mytext({
    required this.txt,
    this.color =const Color(0xff030303),
    this.size = 30,
    this.decoration = TextDecoration.none,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        decoration: decoration,
        color: color,
        fontFamily: 'Mulish',
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
