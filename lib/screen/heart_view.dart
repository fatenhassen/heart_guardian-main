import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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

  final List<double> heartRates = [];
  final List<double> spo2Levels = [];
  final List<String> timeLabels = [];

  bool showAppBar = false;

  late AnimationController _controller;
  late Animation<double> _heartAnimation;
  late Animation<double> _oxygenAnimation;
  late StreamSubscription<DatabaseEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _listenToLiveData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    setState(() {
      showAppBar = args?['showAppBar'] ?? false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _initAnimations() {
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

  void _listenToLiveData() {
    _subscription = _database.child('sensorData').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data == null || !mounted) return;

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
    });
  }

  PreferredSizeWidget? _buildAppBar() {
    if (!showAppBar) return null;

    return AppBar(
      backgroundColor: const Color(0xFFA0D1EF),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      title: const Text(
        'Heart Monitor',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
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
      ),
    );
  }
}
