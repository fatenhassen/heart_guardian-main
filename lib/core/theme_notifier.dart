import 'package:flutter/material.dart';
import 'app_theme.dart'; // تأكد إن الملف اللي فيه الثيم اسمه كده

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeNotifier();

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? appDarkTheme : appLightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
