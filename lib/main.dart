import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heart_guardian/screen/home_view.dart';
import 'package:heart_guardian/widgets/VerifyCodeScreen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:heart_guardian/core/app_theme.dart';
import 'package:heart_guardian/core/theme_notifier.dart';
import 'package:heart_guardian/firebase_options.dart';
import 'package:heart_guardian/screen/splash_screen.dart';
import 'package:heart_guardian/settings/help_support.dart';
import 'package:heart_guardian/settings/privacy_screen.dart';

// ✅ إنشاء كائن الإشعارات
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ تهيئة الإشعارات المحلية
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ThemeNotifier())],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Heart Guardian',
          theme: appLightTheme,
          darkTheme: appDarkTheme,
          themeMode:
              themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: SplashScreen(),
          routes: {
            '/privacy': (context) => const PrivacyScreen(),
            '/help': (context) => const HelpSupportScreen(),
          },
        );
      },
    );
  }
}
