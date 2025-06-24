import 'package:flutter/material.dart';

import '../customs_widgets/mytext.dart';

class TimeWakeup extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimeWakeup({
    super.key,
    required this.label,
    required this.time,
    required this.onTimeChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null) onTimeChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),

        Mytext(
          decoration: TextDecoration.underline,
          txt: "Choose wake-up time",
          size: 26,
        ),
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset(
                'assets/images/wakeup.png',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
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
        ),
      ],
    );
  }
}
