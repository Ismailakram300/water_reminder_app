import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../customs_widgets/appbar.dart';
import '../notification_service.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  int selectedInterval = 0; // 0 = none selected

  final List<int> reminderOptions = [30, 60, 120, 180, 240];

  @override
  void initState() {
    super.initState();
    loadSavedInterval();
    requestNotificationPermission();

  }

  Future<void> requestNotificationPermission() async {
    // Add your permission logic if needed
  }


  Future<void> loadSavedInterval() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedInterval = prefs.getInt('selectedInterval') ?? 0;
    });
  }

  Future<void> saveSelectedInterval(int? minutes) async {
    final prefs = await SharedPreferences.getInstance();
    if (minutes != null && minutes > 0) {
      await prefs.setInt('selectedInterval', minutes);
    } else {
      await prefs.remove('selectedInterval');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Reminder'),
      body: Container(
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

                // Cancel existing reminders
                await NotificationService.cancelAllNotifications();

                if (val) {
                  // Save new selected interval and schedule notification
                  await saveSelectedInterval(minutes);
                  await NotificationService.scheduleRepeating(minutes);
                } else {
                  // Clear saved interval
                  await saveSelectedInterval(null);
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
      color: Color(0xffEFF7FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(label),
        subtitle: Text("Auto Reminder",style: TextStyle(fontFamily: 'Mulish',)),
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
