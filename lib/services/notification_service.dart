import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// This class handles scheduling local notifications for task deadlines.
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Constructor that initializes the notification settings.
  NotificationService() {
    _initializeNotifications();
  }

  /// Initializes the notification settings for the application.
  Future<void> _initializeNotifications() async {
    // Initialize the timezones
    tz.initializeTimeZones();

    // Android specific initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // General initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize the plugin with the settings
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Schedules a notification at a specified date and time.
  ///
  /// [id] is the notification ID.
  /// [title] is the title of the notification.
  /// [body] is the body text of the notification.
  /// [scheduledDate] is the date and time when the notification should be triggered.
  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    // Convert the scheduled date to a timezone aware datetime
    final tz.TZDateTime tzScheduledDate =
        tz.TZDateTime.from(scheduledDate, tz.local);

    // Android specific notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_deadlines_channel_id', // Channel ID
      'Task Deadline Incoming!', // Channel name
      channelDescription:
          'One or more of your task deadlines are in 10 minutes!', // Channel description
      importance: Importance.max, // Importance level
      priority: Priority.high, // Priority level
    );

    // General notification details
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // Notification ID
      title, // Notification title
      body, // Notification body
      tzScheduledDate, // Scheduled date and time
      platformChannelSpecifics, // Notification details
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // Schedule mode
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime, // Date interpretation
    );
  }
}
