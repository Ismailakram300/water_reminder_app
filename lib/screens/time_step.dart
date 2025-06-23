import 'package:flutter/material.dart';

class TimeStep extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimeStep({
    super.key,
    required this.label,
    required this.time,
    required this.onTimeChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null) onTimeChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Icon(Icons.access_alarm, size: 100, color: Colors.blue),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
      ],
    );
  }
}
