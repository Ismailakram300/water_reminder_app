import 'package:flutter/material.dart';
// import '../widgets/onboarding_progress_header.dart';
// import '../widgets/gender_step.dart';
// import '../widgets/weight_step.dart';
// import '../widgets/time_step.dart';

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

    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // OnboardingProgressHeader(
            //   currentStep: currentStep,
            //   gender: selectedGender,
            //   weight: selectedWeight,
            //   wakeUpTime: wakeUpTime,
            //   sleepTime: sleepTime,
            // ),
            const SizedBox(height: 20),
            Expanded(child: steps[currentStep]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.blue),
                  onPressed: previousStep,
                ),
                ElevatedButton(
                  onPressed: nextStep,
                  child: Text(currentStep == 3 ? "Finish" : "Next"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
