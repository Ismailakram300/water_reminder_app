import 'package:flutter/material.dart';
import 'package:water_reminder_app/customs_widgets/mytext.dart';

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
      {'image': "assets/images/malefemale.png", 'label': gender},
      {'image': "assets/images/kg.png", 'label': '${weight}kg'},
      {'image':"assets/images/alarm_time.png", 'label': _formatTime(wakeUpTime)},
      {'image': "assets/images/bed.png", 'label': _formatTime(sleepTime)},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 55, 0,0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: steps.asMap().entries.map((entry) {
            int index = entry.key;
            var step = entry.value;
            bool selected = currentStep == index;
            Color getStepColor(int index) {
              if (currentStep == index) return Colors.blue;
              if (currentStep > index) return Colors.blue;
              return Colors.grey[300]!;
            }


            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: getStepColor(index) ,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    step['image'] as String,
                    width: 45,
                    height: 20,
                    color: Colors.white,
                  ),              ),
                const SizedBox(height: 4),
                Mytext(txt:step['label']  as String ,size: 11),
              ],
            ) ;
          }).toList(),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
