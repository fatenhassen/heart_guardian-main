import 'package:flutter/material.dart';
import 'package:heart_guardian/core/theme_notifier.dart';
import 'package:heart_guardian/screen/notification_screen.dart';
import 'package:heart_guardian/screen/welcome_view.dart';
import 'package:heart_guardian/settings/help_support.dart';
import 'package:heart_guardian/settings/language_screen.dart';
import 'package:heart_guardian/widgets/settings_card.dart';
import 'package:heart_guardian/widgets/settings_item.dart';
import 'package:heart_guardian/widgets/settings_section_title.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:heart_guardian/screen/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA0D1EF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 100,
        title: Text(
          'settings'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Agbalumo',
          fontSize: 16,
          color: textColor,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSectionTitle(title: 'account'.tr(), color: textColor),
              SettingsCard(
                children: [
                  SettingsItem(
                    icon: Icons.person_outline,
                    title: 'account'.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(userId: '123',),
                        ),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.language_outlined,
                    title: 'language'.tr(),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.locale.languageCode == 'ar'
                              ? 'arabic'.tr()
                              : 'english'.tr(),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 22),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LanguageScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.notifications_active_outlined,
                    title: 'notifications'.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),

                  Consumer<ThemeNotifier>(
                    builder: (context, themeNotifier, child) {
                      return SettingsItem(
                        icon: Icons.brightness_4_outlined,
                        title: 'dark_mode'.tr(),
                        trailing: Switch(
                          value: themeNotifier.isDarkMode,
                          onChanged: (_) => themeNotifier.toggleTheme(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              SettingsSectionTitle(
                title: 'support_about'.tr(),
                color: textColor,
              ),
              SettingsCard(
                children: [
                  SettingsItem(
                    icon: Icons.lock_outline,
                    title: 'privacy'.tr(),
                    onTap: () => Navigator.pushNamed(context, '/privacy'),
                  ),
                  SettingsItem(
                    icon: Icons.question_mark_rounded,
                    title: 'help_support'.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              SettingsSectionTitle(title: 'actions'.tr(), color: textColor),
              SettingsCard(
                children: [
                  SettingsItem(
                    icon: Icons.group_add_outlined,
                    title: 'add_account'.tr(),
                  ),
                  SettingsItem(
                    icon: Icons.logout_outlined,
                    title: 'logout'.tr(),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const WelcomePage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
