import 'package:flutter/material.dart';
import 'package:photo_sync/util/enums/appearance_mode_type.dart';

class Appearance {
  Appearance({AppearanceModeType? type}) {
    if (type != null) _currentType = type;
  }

  AppearanceModeType _currentType = AppearanceModeType.Follow_System;
  void changeType(AppearanceModeType newType) => _currentType = newType;

  AppearanceModeType get currentType => _currentType;

  ///Returns the ThemeData assigned to the currentType
  ThemeData get currentThemeData {
    if (_currentType == AppearanceModeType.Dark_Mode) return _darkThemeData;
    if (_currentType == AppearanceModeType.Light_Mode) return _lightThemeData;
    if (MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
            .platformBrightness ==
        Brightness.dark) return _darkThemeData;
    return _lightThemeData;
  }

  bool get isDarkMode {
    if (_currentType == AppearanceModeType.Dark_Mode) return true;
    if (_currentType == AppearanceModeType.Light_Mode) return false;
    return MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
            .platformBrightness ==
        Brightness.dark;
  }

  ThemeData get lightThemeData => _lightThemeData;

  ThemeData get darkThemeData => _darkThemeData;

  final ThemeData _lightThemeData = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: ThemeData().scaffoldBackgroundColor,
    ),
  );

  final ThemeData _darkThemeData = ThemeData(
    brightness: Brightness.dark,
  );
}
