import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class NotificationService {
  final Logger logger = Logger();

  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Privater Konstruktor für Singleton
  NotificationService._internal();

  // Factory Konstruktor um Singleton Instanz zurückzugeben
  factory NotificationService() {
    return _notificationService;
  }

  // Benachrichtigungseinstellungen für beide Plattformen initialisieren
  Future<void> init() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true);

      const InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      logger.e('Failed to initialize notifications: $e');
    }
  }

  // Show notification with customizable channel details
  Future<void> showNotification(
      String channelId, String channelName, String channelDescription) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              'timer_channel', // channelId
              'Timer Benachrichtigung', // channelName
              channelDescription:
                  'Notification channel für timer', // channelDescription
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');

      const DarwinNotificationDetails darwinPlatformChannelSpecifics =
          DarwinNotificationDetails(
              sound: 'notification_sound.aiff',
              badgeNumber: 1,
              subtitle: 'Timer Benachrichtigung',
              presentAlert: true,
              presentBadge: true,
              presentSound: true);

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: darwinPlatformChannelSpecifics,
          macOS: darwinPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
          0, // Notification ID
          'Timer', // Notification titel
          'Timer abgelaufen', // Notification body
          platformChannelSpecifics);
    } catch (e) {
      logger.e('Failed to show notification: $e');
    }
  }
}
