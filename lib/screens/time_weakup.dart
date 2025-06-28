import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../customs_widgets/mytext.dart';

class TimeWakeup extends StatefulWidget {
  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimeWakeup({
    super.key,
    required this.label,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  State<TimeWakeup> createState() => _TimeWakeupState();
}

class _TimeWakeupState extends State<TimeWakeup> {
  late int _selectedHour = widget.time.hour;
  late int _selectedMinute =  widget.time.minute;

  void _updateTime() {
    widget.onTimeChanged(TimeOfDay(
      hour: _selectedHour,
      minute: _selectedMinute,
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Mytext(
          decoration: TextDecoration.underline,
          txt: "Choose wake-up Time",
          size: 26,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset(
                'assets/images/wakeup.png',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NumberPicker(
                    selectedTextStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    minValue: 0,
                    maxValue: 23,
                    itemHeight: 45,
                    itemWidth: 40,
                    value: _selectedHour,
                    textStyle: TextStyle(color: Color(0xff6C6C6C), fontSize: 25),

                    zeroPad: true,
                    onChanged: (value) =>
                    { setState(() => _selectedHour = value),
                      _updateTime()},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                  child: NumberPicker(
                    selectedTextStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    minValue: 0,
                    maxValue: 59,
                    itemHeight: 45,
                    itemWidth: 40,
                    value: _selectedMinute,
                    zeroPad: true,
                    onChanged: (value) =>
                        setState(() => _selectedMinute = value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
