import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialiseNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          print('Notification payload: $payload');
        }
      },
    );
  }

  Future<void> scheduleNotification(
      DateTime scheduledTime, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medication_channel',
      'Medication Reminders',
      channelDescription: 'Medication reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'reminder',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future<void> scheduleRecurringNotification(DateTime scheduledTime,
      String title, String body, Duration interval) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medication_channel',
      'Medication Reminders',
      channelDescription: 'Medication reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        title,
        body,
        tz.TZDateTime.from(scheduledTime.add(interval), tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'reminder',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime);
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
