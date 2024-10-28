import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service with platform-specific settings and notification channel
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    // Create a notification channel for Android 8.0+ (required for notifications to show in settings)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Unique channel ID
      'High Importance Notifications', // Channel name visible to user
      description:
          'Channel for important notifications.', // Channel description
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Request permissions on iOS for notifications

  static Future<void> requestPermission() async {
    // iOS request
    final iosPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Android 13+ request
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // Schedule a notification with a specified title, body, schedule time, and ID
  static Future<void> showScheduledNotification(
      String title, String body, tz.TZDateTime schedule, int id) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel', // Must match channel ID created in init()
      'Scheduled Notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    print('Notification scheduled at $schedule');

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      schedule,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  // Cancel a scheduled notification by its ID
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Handle the tap on notification events
  static void onTap(NotificationResponse notificationResponse) {
    print('Notification tapped with payload: ${notificationResponse.payload}');
    // Implement additional logic for when a notification is tapped if necessary
  }
}
