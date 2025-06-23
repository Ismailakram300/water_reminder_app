import 'package:flutter/cupertino.dart';

class Mytext extends StatelessWidget {
final String txt;
   Mytext({required this.txt,super.key});

  @override
  Widget build(BuildContext context) {
    return Text(txt, style: TextStyle(color: Color(0xff030303,),
    fontSize: 30),);
  }
}
