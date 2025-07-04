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
            txt: "Select your Gender",
            size: 26,

          ),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Male
            GestureDetector(
              onTap: () => onChanged('Male'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    child: Image.asset('assets/images/male.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,11,0),
                    child: Row(
                     // mainAxisSize: MainAxisSize.min,
                      children: [

                        Radio<String>(
                          value: 'Male',
                          groupValue: selectedGender,
                          onChanged: (val) => onChanged(val!),
                          activeColor: Colors.blue,
                        ),
                        Mytext(
                          txt: 'Male',
                          size: 15,
                          color: selectedGender == 'Male'
                              ? Color(0xff278DE8)
                              : Color(0xff979797),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Female
            GestureDetector(
              onTap: () => onChanged('Female'),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    child: Image.asset('assets/images/female.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,12,0),
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'Female',
                          groupValue: selectedGender,
                          onChanged: (val) => onChanged(val!),
                          activeColor: Colors.blue,
                        ),
                        Mytext(
                          txt: 'Female',
                          size: 15,
                          color: selectedGender == 'Female'
                              ? Color(0xff278DE8)
                              : Color(0xff979797),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ],
    );

  }
}
