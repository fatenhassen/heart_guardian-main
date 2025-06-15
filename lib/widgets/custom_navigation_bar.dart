import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ دعم الترجمة

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // تحديد الألوان حسب الثيم
    final navBarColor = isDark ? Color(0xFF042D46) : const Color(0xFF6BAED6);
    final buttonColor = isDark ? Color(0xFF042D46) : const Color(0xFF045C8C);
    final iconColor = Colors.white;

    return CurvedNavigationBar(
      index: currentIndex,
      height: 75.0,
      items: [
        Tooltip(
          message: tr('home'),
          child: Icon(Icons.home_outlined, size: 30, color: iconColor),
        ),
        Tooltip(
          message: tr('heart'),
          child: Icon(Icons.monitor_heart, size: 30, color: iconColor),
        ),
        Tooltip(
          message: tr('profile'),
          child: Icon(Icons.person, size: 30, color: iconColor),
        ),
      ],
      color: navBarColor,
      buttonBackgroundColor: buttonColor,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: onTap,
      letIndexChange: (index) => true,
    );
  }
}
