import 'package:flutter/material.dart';
import 'package:water_reminder_app/customs_widgets/mytext.dart';
import 'package:water_reminder_app/screens/home_screen.dart';
import 'package:water_reminder_app/screens/time_step.dart';
import 'package:water_reminder_app/screens/time_weakup.dart';
import 'package:water_reminder_app/screens/weight_step.dart';

import 'gender_step.dart';
import 'onboarding_progress_header.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentStep = 0;
  String selectedGender = 'Male';
  int selectedWeight = 40;
  TimeOfDay wakeUpTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay sleepTime = const TimeOfDay(hour: 6, minute: 0);

  void nextStep() {
    if (currentStep < 3) {
      setState(() => currentStep++);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      GenderStep(
        selectedGender: selectedGender,
        onChanged: (val) => setState(() => selectedGender = val),
      ),
      WeightStep(
        weight: selectedWeight,
        onChanged: (val) => setState(() => selectedWeight = val),
      ),
      TimeWakeup(
        label: "Choose wake-up time",
        time: wakeUpTime,
        onTimeChanged: (val) => setState(() => wakeUpTime = val),
      ),
      TimeStep(
        label: "Choose sleep time",
        time: sleepTime,
        onTimeChanged: (val) => setState(() => sleepTime = val),
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xffEFF7FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OnboardingProgressHeader(
              currentStep: currentStep,
              gender: selectedGender,
              weight: selectedWeight,
              wakeUpTime: wakeUpTime,
              sleepTime: sleepTime,
            ),
            const SizedBox(height: 20),
            Container(height: 450, child: steps[currentStep]),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ?currentStep != 0
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xff278DE8),
                          ),
                          width: 45,
                          height: 45,
                          child: InkWell(
                            onTap: previousStep,
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Color(0xff278DE8),
                    ),
                    width: 76,
                    height: 41,
                    child: InkWell(
                      onTap: nextStep,
                      child: Center(
                        child: Mytext(
                          txt: currentStep == 3 ? "Finish" : "Next",
                          size: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
