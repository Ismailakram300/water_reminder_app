import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder_app/customs_widgets/mytext.dart';
import 'package:water_reminder_app/screens/home_screen.dart';
import 'package:water_reminder_app/screens/time_step.dart';
import 'package:water_reminder_app/screens/time_weakup.dart';
import 'package:water_reminder_app/screens/weight_step.dart';

import '../Database/database_helper.dart';
import 'bottom_nav_bar.dart';
import 'gender_step.dart';
import 'onboarding_progress_header.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  bool onboardingComplete=false;
  int currentStep = 0;
  String selectedGender = 'Male';
  int selectedWeight = 40;
  TimeOfDay wakeUpTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay sleepTime = const TimeOfDay(hour: 6, minute: 0);

  void completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }
  void nextStep() async {
    if (currentStep < 3) {

      setState(() => currentStep++);
    } else {
      await DatabaseHelper.instance.saveUserData(
        gender: selectedGender,
        weight: selectedWeight,
        wakeUp: wakeUpTime.format(context),
        sleep: sleepTime.format(context),
        dailyGoal: 2500,
      );
      checkUserData();
      completeOnboarding();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  void checkUserData() async {
    final data = await DatabaseHelper.instance.getUserData();
    if (data != null) {
      print("✔️ Data Found in DB:");
      print("Gender: ${data['gender']}");
      print("Weight: ${data['weight']}");
      print("Weight: ${data['dailyGoal']}");
      print("Wake-up Time: ${data['wakeUpTime']}");
      print("Sleep Time: ${data['sleepTime']}");
    } else {
      print("❌ No user data found in database.");
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
