import 'package:flutter/cupertino.dart';

class Mytext extends StatelessWidget {
  final String txt;
  final double size;

  Mytext({required this.txt, this.size = 30, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        color: Color(0xff030303),
        fontFamily: 'Mulish',
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
