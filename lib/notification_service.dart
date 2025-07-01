import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    tz.initializeTimeZones(); // Required for scheduling
    print("🔔 Notification Service Initialized");
  }

  /// Cancel all scheduled notifications
  static Future<void> cancelAllReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print("❌ All notifications cancelled");
  }

  /// Schedule a reminder after [intervalMinutes]
  static Future<void> scheduleReminder(int intervalMinutes) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(Duration(minutes: intervalMinutes));

    print("⏰ Scheduling reminder in $intervalMinutes minutes at $scheduledTime");
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Auto water intake reminders',
      importance: Importance.max,  // ✅ Required
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );


    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Water Reminder',
      'Time to drink water 💧',
      scheduledTime,
      notificationDetails,
       androidScheduleMode: AndroidScheduleMode.exact, // ✅ new parameter
    );
  }

}
