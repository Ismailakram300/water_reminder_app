import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingProgressHeader extends StatelessWidget {
  final int currentStep;

  const OnboardingProgressHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'icon': Icons.transgender, 'label': 'Male'},
      {'icon': Icons.fitness_center, 'label': '40kg'},
      {'icon': Icons.access_time, 'label': '06:00'},
      {'icon': Icons.bedtime, 'label': '06:00'},
    ];

    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: steps.asMap().entries.map((entry) {
            int index = entry.key;
            var step = entry.value;
            bool selected = currentStep == index;
        
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(step['icon'] as IconData, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  step['label'] as String,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
