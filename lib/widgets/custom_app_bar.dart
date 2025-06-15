import 'package:flutter/material.dart';
import 'package:heart_guardian/screen/notification_screen.dart';
import 'package:heart_guardian/screen/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:heart_guardian/core/theme_notifier.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ دعم الترجمة

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          /// صورة البروفايل
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundImage: const AssetImage("assets/Images/Profil.png"),
          ),
          const Spacer(),

          /// أيقونات الإشعارات والإعدادات وتغيير الوضع
          Row(
            children: [
              Tooltip(
                message: tr('notification'),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_on_outlined,
                    size: 26,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              Tooltip(
                message: tr('settings'),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 26,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              Tooltip(
                message:
                    themeNotifier.isDarkMode
                        ? tr('switch_to_light_mode')
                        : tr('switch_to_dark_mode'),
                child: IconButton(
                  icon: Icon(
                    themeNotifier.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    size: 26,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    themeNotifier.toggleTheme();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
