import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../notification_service.dart';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  Future<void> setSystemAlarmClock(int afterMinutes) async {
    if (!Platform.isAndroid) return;

    final now = DateTime.now();
    final future = now.add(Duration(minutes: afterMinutes));

    final intent = AndroidIntent(
      action: 'android.intent.action.SET_ALARM',
      arguments: {
        'android.intent.extra.alarm.HOUR': future.hour,
        'android.intent.extra.alarm.MINUTES': future.minute,
        'android.intent.extra.alarm.MESSAGE': 'Drink Water 💧',
        'android.intent.extra.alarm.SKIP_UI': false,
      },
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    try {
      await intent.launch();
    } catch (e) {
      print("🚨 Failed to launch alarm intent: $e");
    }

  }

  int selectedInterval = 30; // 30 minutes default
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
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
                  selectedInterval = minutes;
                });
                await NotificationService.cancelAllReminders();         // Cancel existing notification
                await NotificationService.scheduleReminder(minutes);    // Schedule new notification
                await setSystemAlarmClock(minutes);                     // Set alarm in Android clock
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
