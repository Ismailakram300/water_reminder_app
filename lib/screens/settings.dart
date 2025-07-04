import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:water_reminder_app/screens/reminder.dart';

import '../Database/database_helper.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void showDailyGoalDialog(BuildContext context, int initialValue) {
    int currentValue = initialValue;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),

          ),
          title: Text(
            "Daily Goal",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NumberPicker(
                    value: currentValue,
                    minValue: 100,
                    maxValue: 10000,
                    step: 50,
                    haptics: true,
                    onChanged: (value) => setState(() => currentValue = value),
                    selectedTextStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 28,
                    ),
                    textStyle: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  Text(
                    "ml",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.updateDailyGoal(currentValue);
                await DatabaseHelper.instance.debugPrintAllUserData();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Daily goal set to $currentValue ml")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showWeightDialog(BuildContext context, int initialValue) {
    int weightValue = initialValue;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Weight", style: TextStyle(fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NumberPicker(
                    value: weightValue,
                    minValue: 10,
                    maxValue: 120,
                    step: 50,
                    haptics: true,
                    onChanged: (value) => setState(() => weightValue = value),
                    selectedTextStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 28,
                    ),
                    textStyle: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  Text(
                    "kg",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.updateWeight(weightValue);
                await DatabaseHelper.instance.debugPrintAllUserData();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Weight set to $weightValue Kl")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
  void showWakeUpTimeDialog(BuildContext context, TimeOfDay initialTime) {
    int selectedHour = initialTime.hour;
    int selectedMinute = initialTime.minute;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Wake Up Time", style: TextStyle(fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Hour", style: TextStyle(color: Colors.grey)),
                      NumberPicker(
                        value: selectedHour,
                        minValue: 0,
                        maxValue: 23,
                        zeroPad: true,
                        onChanged: (value) => setState(() => selectedHour = value),
                        selectedTextStyle: TextStyle(color: Colors.blue, fontSize: 24),
                        textStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Minute", style: TextStyle(color: Colors.grey)),
                      NumberPicker(
                        value: selectedMinute,
                        minValue: 0,
                        maxValue: 59,
                        zeroPad: true,
                        onChanged: (value) => setState(() => selectedMinute = value),
                        selectedTextStyle: TextStyle(color: Colors.blue, fontSize: 24),
                        textStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newTime = TimeOfDay(hour: selectedHour, minute: selectedMinute);
                await DatabaseHelper.instance.updateWakeUpTime(newTime);
                await DatabaseHelper.instance.debugPrintAllUserData();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Wake-up time set to ${newTime.format(context)}")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showGenderDialog(BuildContext context, String initialGender) {
    String selectedGender = initialGender;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Select Gender",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text("Male"),
                    value: "Male",
                    groupValue: selectedGender,
                    onChanged: (value) =>
                        setState(() => selectedGender = value!),
                  ),
                  RadioListTile<String>(
                    title: Text("Female"),
                    value: "Female",
                    groupValue: selectedGender,
                    onChanged: (value) =>
                        setState(() => selectedGender = value!),
                  ),
                  RadioListTile<String>(
                    title: Text("Other"),
                    value: "Other",
                    groupValue: selectedGender,
                    onChanged: (value) =>
                        setState(() => selectedGender = value!),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.updateGender(selectedGender);
                await DatabaseHelper.instance.debugPrintAllUserData();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gender set to $selectedGender")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  String selectedSound = "Chime";
  void _showSoundPicker(BuildContext context) {
    List<String> sounds = ["Chime", "Bell", "Beep", "Drop"];
    String tempSelectedSound =
        selectedSound; // to update temporarily inside dialog

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Reminder Sound"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: sounds.map((sound) {
                  return RadioListTile<String>(
                    title: Text(sound),
                    value: sound,
                    groupValue: tempSelectedSound,
                    onChanged: (value) {
                      setState(() {
                        tempSelectedSound = value!;
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedSound = tempSelectedSound;
                });
                Navigator.pop(context);
                // You can also save it to preferences here if needed
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF7FF),
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle("General"),
          _buildSettingsTile(
            "Reminder Sound",
            onTap: () => _showSoundPicker(context),
          ),
          _buildSettingsTile(
            "Reminder",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReminderScreen()),
            ),
          ),
          _buildSettingsTile(
            "Daily Goal",
            onTap: () async {
              final userData = await DatabaseHelper.instance.getUserData();
              final currentGoal = userData?['dailyGoal'] ?? 2000;

              showDailyGoalDialog(context, currentGoal);
            },
          ),

          SizedBox(height: 20),
          _buildSectionTitle("Personal Information"),
          _buildSettingsTile(
            "Gender",
            onTap: () async {
              final userData = await DatabaseHelper.instance.getUserData();
              final currentGoal = userData?['gender'] ?? 'other';
              showGenderDialog(context, currentGoal);
            },
          ),
          _buildSettingsTile("Weight",
          onTap: ()async{
            final userData = await DatabaseHelper.instance.getUserData();
            final currentGoal = userData?['weight'] ?? 40;
            showWeightDialog(context, currentGoal);
          }
          ),
      //import 'package:intl/intl.dart';

      _buildSettingsTile(
      "Wake-up time",
      onTap: () async {
        final userData = await DatabaseHelper.instance.getUserData();
        String storedTime = userData?['wakeUpTime'] ?? '07:00 AM';

        // ✅ Normalize ALL invisible space characters
        storedTime = storedTime.replaceAll(RegExp(r'[^\x00-\x7F]'), '').trim();


        try {
          final parsedDate = DateFormat.jm().parse(storedTime);
          final currentTime = TimeOfDay(hour: parsedDate.hour, minute: parsedDate.minute);
          showWakeUpTimeDialog(context, currentTime);
        } catch (e) {
          print("⛔ Error parsing cleaned time: $storedTime — $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid wake-up time format: $storedTime")),
          );
        }
      },
    ),




    _buildSettingsTile("Bedtime"),

          SizedBox(height: 20),
          _buildSectionTitle("Other"),
          _buildSettingsTile("Rate Us"),
          _buildSettingsTile("Privacy Policy"),
          _buildSettingsTile("Share"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xff278DE8),
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String label, {VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(color: Color(0xff727272), fontSize: 12),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
