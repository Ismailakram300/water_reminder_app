// alarm_callback.dart
import 'dart:developer';

@pragma('vm:entry-point')
void showReminder() {
  final now = DateTime.now();
  log("🔔 Reminder triggered at $now");
}
