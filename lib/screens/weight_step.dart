import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class WeightStep extends StatelessWidget {
  final int weight;
  final ValueChanged<int> onChanged;

  const WeightStep({super.key, required this.weight, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(height: 20),
        Image.asset('assets/images/weight.png', height: 100), // Optional image
        NumberPicker(
          value: weight,
          minValue: 30,
          maxValue: 150,
          onChanged: onChanged,
        ),
        Text("$weight : kg", style: const TextStyle(fontSize: 18, color: Colors.blue)),
      ],
    );
  }
}
