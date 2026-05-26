import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../libs.dart';

class ThemeChangerViewModel extends ChangeNotifier {
  static const String _themeKey = "themeModeIndex";

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get getThemeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // Colors
  // 1. Primary & Brand Accent Colors
  Color get getPrimaryColor => const Color(0xFF5465FF); // Electric Indigo
  Color get getSecondaryColor => const Color(0xFF7A87FF); // Glow Accent
  Color get getGlowAccentColor => const Color(0xFF7A87FF); // Glow Accent
  Color get getSuccessColor => const Color(0xFF00E676); // Neon Mint Green

  // 2. Background & Surface Colors
  Color get getScaffoldColor =>
      isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC);
  Color get getCardColor =>
      isDarkMode ? const Color(0xFF161B2A) : const Color(0xFFFFFFFF);

  // 3. Text Colors
  Color get getTextColor =>
      isDarkMode ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
  Color get getSecondaryTextColor => const Color(0xFF64748B);

  // General Colors
  Color get getLightColor =>
      isDarkMode ? const Color(0xFF282141) : const Color(0xFF95A1AF);
  Color get getYellowColor =>
      isDarkMode ? const Color(0xffFFC107) : Colors.orange;
  Color get getRedColor => const Color(0xffFF0000);
  Color get getGreenColor => getSuccessColor;
  Color get getBlueColor => const Color(0xff0087ee);
  Color get getOrangeColor => Colors.orange;
  Color get getWhiteColor => isDarkMode ? getCardColor : Colors.white;
  Color get getBlackColor =>
      isDarkMode ? Colors.white : const Color(0xFF0F172A);
  Color get getGreyColor => getSecondaryTextColor;

  // Semantic Colors
  Color get getErrorColor => getRedColor;
  Color get getWarningColor => getYellowColor;
  Color get getPendingColor => getOrangeColor;
  Color get getInfoColor => getBlueColor;
  Color get getDeepDarkColor =>
      isDarkMode ? const Color(0xFF0D1117) : const Color(0xFFE5E7EB);

  ThemeChangerViewModel() {
    loadTheme();
    // Listen for system brightness changes
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      if (_themeMode == ThemeMode.system) {
        _updateSystemUI();
        notifyListeners();
      }
    };
  }

  Future<void> loadTheme() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    // Migration: Check for old boolean key
    if (sp.containsKey("isDarkMode")) {
      final bool isDark = sp.getBool("isDarkMode") ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      await sp.remove("isDarkMode");
      await sp.setInt(_themeKey, _themeMode.index);
    } else {
      final int index = sp.getInt(_themeKey) ?? ThemeMode.system.index;
      _themeMode = ThemeMode.values[index];
    }

    _updateSystemUI();
    notifyListeners();
  }

  ThemeData get getThemeData {
    final bool isDark = isDarkMode;
    final base = isDark ? ThemeData.dark() : ThemeData.light();

    return base.copyWith(
      primaryColor: getPrimaryColor,
      scaffoldBackgroundColor: getScaffoldColor,
      cardColor: getCardColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: getPrimaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: getPrimaryColor,
        secondary: getSecondaryColor,
        surface: getCardColor,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Roboto',
        displayColor: getTextColor,
        bodyColor: getTextColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF161B2A) : getPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void setTheme(ThemeMode mode) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _themeMode = mode;
    await sp.setInt(_themeKey, mode.index);
    _updateSystemUI();
    notifyListeners();
  }

  void _updateSystemUI() {
    if (isDarkMode) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    }
  }
}
