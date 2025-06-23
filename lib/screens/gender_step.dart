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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Male', 'Female'].map((gender) {
              bool isSelected = selectedGender == gender;
              String imagePath = gender == 'Male'
                  ? 'assets/images/male.png'
                  : 'assets/images/female.png';
              return GestureDetector(
                onTap: () => onChanged(gender),
                child: Column(
                  children: [
                  Image.asset(
                  imagePath,
                  height: 100,
                  width: 100,
                 ),
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
      ),
    );
  }
}
