import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heart_guardian/widgets/animated_title.dart';
import 'package:heart_guardian/widgets/custum_line_chart.dart';

import 'package:heart_guardian/main.dart';

class HeartView extends StatefulWidget {
  const HeartView({super.key});

  @override
  State<HeartView> createState() => _HeartViewState();
}

class _HeartViewState extends State<HeartView>
    with SingleTickerProviderStateMixin {
  final _database = FirebaseDatabase.instance.ref();
  List<double> heartRates = [];
  List<double> spo2Levels = [];
  List<String> timeLabels = [];

  late AnimationController _controller;
  late Animation<double> _heartAnimation;
  late Animation<double> _oxygenAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void listenToLiveData() {
    _database.child('sensorData').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final bpmRaw = data['BPM'];
        final spo2Raw = data['SpO2'];

        if (bpmRaw != null && spo2Raw != null) {
          final bpm = double.tryParse(bpmRaw.toString()) ?? 0.0;
          final spo2 = double.tryParse(spo2Raw.toString()) ?? 0.0;

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

          if (bpm < 80 || bpm > 130) {
            sendHeartRateAlert(bpm);
          }
        }
      }
    });
  }

  void sendHeartRateAlert(double bpm) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'heart_alerts', // channel ID
          'Heart Rate Alerts', // channel name
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      '⚠️ Heart Rate Alert',
      'Child’s heart rate is abnormal: $bpm BPM',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool dataReady =
        heartRates.isNotEmpty && spo2Levels.isNotEmpty && timeLabels.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 200),
      child: Column(
        children: [
          AnimatedTitle(text: '🫀 Heart Rate 🫀', animation: _heartAnimation),
          dataReady
              ? CustomLineChart(
                data: heartRates,
                lineColor: Colors.redAccent,
                timeLabels: timeLabels,
              )
              : const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
          const SizedBox(height: 16),
          AnimatedTitle(text: '🌬️ Oxygen 🌬️', animation: _oxygenAnimation),
          dataReady
              ? CustomLineChart(
                data: spo2Levels,
                lineColor: Colors.blue,
                timeLabels: timeLabels,
              )
              : const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
          const SizedBox(height: 30),
          const Text(
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
