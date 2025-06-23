import 'package:flutter/material.dart';

class GenderStep extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const GenderStep({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Choose your gender", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['Male', 'Female'].map((gender) {
            bool isSelected = selectedGender == gender;
            return GestureDetector(
              onTap: () => onChanged(gender),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: isSelected ? Colors.blue[100] : Colors.grey[200],
                    child: Icon(Icons.person, size: 40),
                  ),
                  Radio<String>(
                    value: gender,
                    groupValue: selectedGender,
                    onChanged: (val) => onChanged(val!),
                  ),
                  Text(gender),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
