import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(initSettings);
  }

  static Future<void> showHeartRateAlert(int bpm) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'heart_alerts',
          'Heart Rate Alerts',
          channelDescription: 'Alerts when heart rate is out of safe range',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      0,
      '⚠️ حالة طارئة',
      'معدل ضربات القلب غير طبيعي: $bpm نبضة/دقيقة',
      platformDetails,
    );
  }
}
