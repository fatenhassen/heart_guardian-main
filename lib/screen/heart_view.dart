import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heart_guardian/widgets/animated_title.dart';
import 'package:heart_guardian/widgets/custum_line_chart.dart';

class HeartView extends StatefulWidget {
  const HeartView({super.key});

  @override
  State<HeartView> createState() => _HeartViewState();
}

class _HeartViewState extends State<HeartView>
    with SingleTickerProviderStateMixin {
  final _database = FirebaseDatabase.instance.ref();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<double> heartRates = [];
  List<double> spo2Levels = [];
  List<String> timeLabels = [];

  late AnimationController _controller;
  late Animation<double> _heartAnimation;
  late Animation<double> _oxygenAnimation;

  bool hasNotified = false;

  @override
  void initState() {
    super.initState();
    initNotifications();
    listenToLiveData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _heartAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _oxygenAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showAlertNotification(double bpm) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'alert_channel',
          'Health Alerts',
          channelDescription: 'Notifications for abnormal heart readings',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      '⚠️ Heart Rate Alert',
      'Child heart rate is $bpm bpm. Please check immediately!',
      platformDetails,
    );
  }

  void listenToLiveData() {
    _database.child('sensorData').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final bpm = (data['bpm'] ?? 0).toDouble();
        final spo2 = (data['spo2'] ?? 0).toDouble();

        final now = DateTime.now();
        final formattedTime =
            "${now.hour}:${now.minute.toString().padLeft(2, '0')}";

        setState(() {
          heartRates.add(bpm);
          spo2Levels.add(spo2);
          timeLabels.add(formattedTime);

          if (heartRates.length > 20) {
            heartRates.removeAt(0);
            timeLabels.removeAt(0);
          }
          if (spo2Levels.length > 20) {
            spo2Levels.removeAt(0);
          }
        });

        // 🚨 Alert logic
        if ((bpm < 65 || bpm > 120) && !hasNotified) {
          hasNotified = true;
          showAlertNotification(bpm);

          // Allow alert again after 1 minute
          Future.delayed(const Duration(minutes: 1), () {
            hasNotified = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 200),
      child: Column(
        children: [
          AnimatedTitle(text: '🫀 Heart Rate 🫀', animation: _heartAnimation),
          CustomLineChart(
            data: heartRates,
            lineColor: Colors.redAccent,
            timeLabels: timeLabels,
          ),
          const SizedBox(height: 16),
          AnimatedTitle(text: '🌬️ Oxygen 🌬️', animation: _oxygenAnimation),
          CustomLineChart(
            data: spo2Levels,
            lineColor: Colors.blue,
            timeLabels: timeLabels,
          ),
          const SizedBox(height: 30),
          Text(
            'Your heart rate and oxygen is updated live while using the sensor',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Agbalumo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF656363),
            ),
          ),
        ],
      ),
    );
  }
}
