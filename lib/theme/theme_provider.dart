import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  // Dark Theme
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
    primaryColor: const Color(0xFFFF6B6B),
    cardColor: const Color(0xFF2C2C54),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF6B6B),
      secondary: Color(0xFF00D9FF),
      surface: Color(0xFF2C2C54),
    ),
  );

  // Light Theme
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    primaryColor: const Color(0xFFFF6B6B),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF1A1A2E)),
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1A2E),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFF6B6B),
      secondary: Color(0xFF00D9FF),
      surface: Colors.white,
    ),
  );

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  Color get textColor => _isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
  Color get subtitleColor => _isDarkMode ? Colors.white54 : Colors.black54;
  Color get cardBackground =>
      _isDarkMode ? const Color(0xFF2C2C54) : Colors.white;
  Color get inputBackground =>
      _isDarkMode ? const Color(0xFF2C2C54) : const Color(0xFFF0F0F0);
}
