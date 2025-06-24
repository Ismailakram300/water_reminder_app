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
    mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Center(
          child: Mytext(
            decoration: TextDecoration.underline,
            txt: "Choose your gender",
            size: 26,
          ),
        ),
        const SizedBox(height: 130),
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
                  Container(
                    height: 130,
                    width: 130,

                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      imagePath,

                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Radio<String>(
                        value: gender,
                        groupValue: selectedGender,
                        onChanged: (val) => onChanged(val!),
                        activeColor: Colors.blue,
                      ),
                      Mytext(
                        txt: gender,
                        size: 19,
                        color: isSelected
                            ? Color(0xff278DE8)
                            : Color(0xff979797),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );

  }
}
