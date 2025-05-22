import 'package:shared_preferences/shared_preferences.dart';

class ThemeHelper {
  static const String _keyTheme = 'theme_key';

  static Future<void> saveTheme(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTheme, isDarkMode);
  }

  static Future<bool> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTheme) ?? false;
  }
}