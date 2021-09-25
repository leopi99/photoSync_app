import 'package:flutter/material.dart';
import 'package:photo_sync/util/enums/appearance_mode_type.dart';

class Appearance {
  Appearance({AppearanceModeType? type}) {
    if (type != null) _currentType = type;
  }

  //Default: follow system, will be changed
  AppearanceModeType _currentType = AppearanceModeType.followSystem;
  void changeType(AppearanceModeType newType) => _currentType = newType;

  AppearanceModeType get currentType => _currentType;

  ///Returns the ThemeData assigned to the currentType
  ThemeData get currentThemeData {
    if (_currentType.equals(AppearanceModeType.darkMode)) return _darkThemeData;
    if (_currentType.equals(AppearanceModeType.lightMode)) return _lightThemeData;
    if (MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
            .platformBrightness ==
        Brightness.dark) return _darkThemeData;
    return _lightThemeData;
  }

  bool get isDarkMode {
    if (_currentType.equals(AppearanceModeType.darkMode)) return true;
    if (_currentType.equals(AppearanceModeType.lightMode)) return false;
    return MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
            .platformBrightness ==
        Brightness.dark;
  }

  ThemeData get lightThemeData => _lightThemeData;

  ThemeData get darkThemeData => _darkThemeData;

  final ThemeData _lightThemeData = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  final ThemeData _darkThemeData = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    ),
  );
}
