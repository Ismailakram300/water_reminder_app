import 'package:flutter/material.dart';
import 'package:water_reminder_app/screens/reminder.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  // void _showSoundPicker(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       String selectedSound = "Chime";
  //       List<String> sounds = ["Chime", "Bell", "Beep", "Drop"];
  //
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Container(
  //             padding: EdgeInsets.all(16),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   "Select Reminder Sound",
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 Divider(),
  //                 ...sounds.map((sound) {
  //                   return RadioListTile<String>(
  //                     title: Text(sound),
  //                     value: sound,
  //                     groupValue: selectedSound,
  //                     onChanged: (value) {
  //                       setState(() => selectedSound = value!);
  //                       // TODO: Save selected sound if needed
  //                     },
  //                   );
  //                 }).toList(),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     // TODO: Save or apply selectedSound
  //                   },
  //                   child: Text("Done"),
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[300],
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
          _buildSettingsTile("Daily Goal"),

          SizedBox(height: 20),
          _buildSectionTitle("Personal Information"),
          _buildSettingsTile("Gender"),
          _buildSettingsTile("Weight"),
          _buildSettingsTile("Wake-up time"),
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
          color: Colors.blue,
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
        title: Text(label),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
