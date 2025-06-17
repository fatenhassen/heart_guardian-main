import 'package:flutter/material.dart';
import 'package:heart_guardian/screen/heart_view.dart';
import 'package:heart_guardian/screen/profile_screen.dart';
import 'package:heart_guardian/widgets/custom_app_bar.dart';
import 'package:heart_guardian/widgets/custom_navigation_bar.dart';
import 'package:heart_guardian/widgets/home_screen_content.dart';

class HomeView extends StatefulWidget {
  final int userId;

  const HomeView({super.key, required this.userId});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _pageIndex = 0;

  final List<Widget> _widgetOptions = const [
    HomeScreenContent(),
    HeartView(),
  ];

  void _onNavigationItemTapped(int index) async {
    if (index == 2) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfileScreen(userId: widget.userId.toString()),
        ),
      );

      if (!mounted) return;

      if (result == 0) {
        setState(() {
          _pageIndex = 0;
        });
      }
    } else {
      setState(() {
        _pageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(
          _pageIndex.clamp(0, _widgetOptions.length - 1),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _pageIndex,
        onTap: _onNavigationItemTapped,
      ),
      extendBody: true,
    );
  }
}
