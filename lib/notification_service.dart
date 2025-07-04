import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  /// Initialize once at app start
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'water_reminder_channel',
          channelName: 'Water Reminders',
          channelDescription: 'Periodic water drinking reminders',
          importance: NotificationImportance.High,
          soundSource: null,                        // ← use default alarm sound
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          playSound: true,                          // ← ensure sound plays
          channelShowBadge: true,
          locked: false,
          // enableVibration: true, // optional
        )
      ],
      debug: true,
    );

    // Request permission if needed
    if (!await AwesomeNotifications().isNotificationAllowed()) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  /// Schedule a repeating alarm‐style reminder every [intervalMinutes]
  static Future<void> scheduleRepeating(int intervalMinutes) async {
    final seconds = intervalMinutes * 60;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(

        id: 123,
        channelKey: 'water_reminder_channel',
        title: '💧 Drink Water',
        body:  'Stay hydrated! Time to drink water.',
        notificationLayout: NotificationLayout.Default,
        fullScreenIntent: true,                   // ← wake screen like an alarm
        wakeUpScreen: true,                       // ← ensure screen turns on
      ),
      schedule: NotificationInterval(
        interval: Duration(seconds: seconds),
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        repeats: true,
      ),
    );
  }

  /// Cancel all reminders
  static Future<void> cancelAll() async {
    await AwesomeNotifications().cancelSchedulesByChannelKey('water_reminder_channel');
  }
}
