import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../customs_widgets/mytext.dart';

class WeightStep extends StatelessWidget {
  final int weight;
  final ValueChanged<int> onChanged;

  const WeightStep({super.key, required this.weight, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),

        Mytext(
          decoration: TextDecoration.underline,
          txt: "Choose your gender",
          size: 26,
        ),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset('assets/images/weight.png', height: 300),
            ), // Optional image
            Row(
              children: [
                NumberPicker(
                  selectedTextStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  value: weight,
                  textStyle: TextStyle(color: Color(0xff6C6C6C), fontSize: 25),
                  minValue: 20,
                  itemHeight: 45,
                  itemWidth: 40,
                  maxValue: 150,

                  onChanged: onChanged,
                ),
                Text(
                  ": kg",
                  style: const TextStyle(fontSize: 28, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
