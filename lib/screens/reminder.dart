import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  int selectedInterval = 30; // 30 minutes default

  final List<int> reminderOptions = [30, 60, 120, 180, 240];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onChanged: (val) {
                setState(() {
                  selectedInterval = minutes;
                });
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
