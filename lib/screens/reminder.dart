import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../notification_service.dart';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  int selectedInterval = 30; // 30 minutes default
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    if (Platform.isAndroid && Platform.version.compareTo('12') >= 0) {
      requestExactAlarmPermission();
    }

  }

  Future<void> requestExactAlarmPermission() async {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );

    try {
      await intent.launch();
    } catch (e) {
      print('❌ Failed to open exact alarm permission settings: $e');
    }
  }



  final List<int> reminderOptions = [1, 60, 120, 180, 240];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF7FF),
      appBar: AppBar(
        title: Text("Reminder"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Color(0xFFEFF6FF),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: reminderOptions.length,
          itemBuilder: (context, index) {
            int minutes = reminderOptions[index];
            return ReminderTile(
              label: _getLabel(minutes),
              isSelected: selectedInterval == minutes,
              onChanged: (val) async {
                setState(() {
                  selectedInterval = val ? minutes : 0;
                });

                // 1️⃣ Cancel any existing reminders
                await NotificationService.cancelAll();
               //await NotificationService.cancelAll();

                // If turned on, schedule repeating alarm every [minutes]
                if (val) {
                  await NotificationService.scheduleRepeating(minutes);
                }

                // 2️⃣ If ON: set a system alarm [minutes] from now
                if (val) {
                  final now = DateTime.now().add(Duration(minutes: minutes));
                  FlutterAlarmClock.createAlarm(
                  hour:   now.hour,
                   minutes:  now.minute,
                    title: '💧 Drink Water',
                  );
                }
              },



            );
          },
        ),
      ),
    );
  }

  String _getLabel(int minutes) {
    if (minutes < 60) return "$minutes Minutes";
    return "${minutes ~/ 60} ${minutes == 60 ? 'Hour' : 'Hours'}";
  }
}

class ReminderTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const ReminderTile({
    required this.label,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(label),
        subtitle: Text("Auto Reminder"),
        trailing: Switch(
          value: isSelected,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
        onTap: () => onChanged(!isSelected),
      ),
    );
  }
}
