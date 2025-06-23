import 'package:flutter/material.dart';

class OnboardingProgressHeader extends StatelessWidget {
  final int currentStep;
  final String gender;
  final int weight;
  final TimeOfDay wakeUpTime;
  final TimeOfDay sleepTime;

  const OnboardingProgressHeader({
    super.key,
    required this.currentStep,
    required this.gender,
    required this.weight,
    required this.wakeUpTime,
    required this.sleepTime,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'icon': Icons.transgender, 'label': gender},
      {'icon': Icons.fitness_center, 'label': '${weight}kg'},
      {'icon': Icons.access_time, 'label': _formatTime(wakeUpTime)},
      {'icon': Icons.bedtime, 'label': _formatTime(sleepTime)},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            Text(step['label'] as String),
          ],
        );
      }).toList(),
    );
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
