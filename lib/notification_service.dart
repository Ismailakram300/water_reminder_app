import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:water_reminder_app/screens/alarm_callback.dart';

class NotificationService {
  static const int alarmId = 100;

  static Future<void> scheduleReminder({int intervalMinutes = 1}) async {
    await AndroidAlarmManager.periodic(
      Duration(minutes: intervalMinutes),
      alarmId,
      showReminder, // Top-level function only!
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  static Future<void> cancelReminder() async {
    await AndroidAlarmManager.cancel(alarmId);
  }
}
