import 'package:flutter/material.dart';
import 'package:water_reminder_app/customs_widgets/mytext.dart';

class GenderStep extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const GenderStep({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
           Mytext(txt:"Choose your gender", ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['Male', 'Female'].map((gender) {
            bool isSelected = selectedGender == gender;
            return GestureDetector(
              onTap: () => onChanged(gender),
              child: Column(
                children: [
               Image(image: AssetImage("assets/images/water.png")),
                  Radio<String>(
                    value: gender,
                    groupValue: selectedGender,
                    onChanged: (val) => onChanged(val!),
                  ),
                  Mytext(txt: gender),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
