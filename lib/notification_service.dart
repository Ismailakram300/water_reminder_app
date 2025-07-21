import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'default_water_reminder',
          channelName: 'Default Water Reminder',
          channelDescription: 'Basic water reminder notifications',
          importance: NotificationImportance.High,
          playSound: true,
          defaultColor: Colors.blue,
          channelShowBadge: true,
          //channelShowBadge: true,
          locked: false,
        ),
      ],
      debug: true,
    );

    if (!await AwesomeNotifications().isNotificationAllowed()) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  /// Initialize once at app start
  static Future<void> createChannelForSound(String sound) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'water_reminder_$sound',
          channelName: 'Water Reminder - $sound',
          channelDescription: 'Reminders with $sound sound',
          importance: NotificationImportance.High,
          playSound: true,
          soundSource: 'resource://raw/${sound.toLowerCase()}',
          defaultColor: Colors.blue,
          channelShowBadge: true,
          locked: false,
        )
      ],
      debug: true,
    );
    if (!await AwesomeNotifications().isNotificationAllowed()) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }


  /// Schedule a repeating alarm‐style reminder every [intervalMinutes]
  static Future<void> scheduleRepeating(int intervalMinutes) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedSound = prefs.getString('selectedSound') ?? 'chime';

    final seconds = intervalMinutes * 60;

    // Create (or re-use) channel with sound
    await createChannelForSound(selectedSound);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 123,
        channelKey: 'water_reminder_$selectedSound',
        title: '💧 Drink Water',
        body: 'Stay hydrated! Time to drink water.',
        notificationLayout: NotificationLayout.Default,
        fullScreenIntent: true,
        wakeUpScreen: true,
      ),
      schedule: NotificationInterval(
        interval: Duration(seconds: seconds),
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        repeats: true,
      ),
    );
  }

  /// Cancel all reminders
  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  static Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> cancelChannelNotifications(String channelKey) async {
    await AwesomeNotifications().cancelSchedulesByChannelKey(channelKey);
  }
}
