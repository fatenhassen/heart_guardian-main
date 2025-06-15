import 'package:flutter/material.dart';
import 'package:heart_guardian/widgets/notification_appbar.dart';
import 'package:heart_guardian/widgets/notification_header.dart';
import 'package:heart_guardian/widgets/notification_items.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: NotificationAppBar(),
      body: Column(
        children: const [
          NotificationHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  NotificationItem(
                    icon: Icons.person_outline,
                    title: 'check_on_child',
                    subtitle: 'check_on_child_msg',
                    time: '1h',
                  ),
                  NotificationItem(
                    icon: Icons.camera_alt_outlined,
                    title: 'open_camera',
                    subtitle: 'open_camera_msg',
                    time: '2h',
                  ),
                  NotificationItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'ask_about_day',
                    subtitle: 'ask_about_day_msg',
                    time: '3h',
                  ),
                  NotificationItem(
                    icon: Icons.favorite_border,
                    title: 'health_check',
                    subtitle: 'health_check_msg',
                    time: '4h',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
