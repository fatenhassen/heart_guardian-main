import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heart_guardian/core/theme_notifier.dart';
import '../widgets/settings_item.dart';

class DarkModeSwitchItem extends StatelessWidget {
  const DarkModeSwitchItem({super.key});
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return SettingsItem(
      icon: Icons.brightness_4_outlined,
      title: 'Dark Mode',
      trailing: Switch(
        value: themeNotifier.isDarkMode,
        onChanged: (value) {
          themeNotifier.toggleTheme();
        },
      ),
    );
  }
}
