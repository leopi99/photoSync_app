import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';

class GlobalMethods {
  static Future<void> setStatusBarColorAsScaffoldBackground(
      {bool? whiteForeground}) async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(
        AppearanceBlocInherited.of(navigatorKey.currentContext!)
            .appearance
            .isDarkMode);
    await FlutterStatusbarcolor.setStatusBarColor(
        AppearanceBlocInherited.of(navigatorKey.currentContext!)
            .appearance
            .currentThemeData
            .scaffoldBackgroundColor);
  }

  static Future<void> setStatusBarColorForDialog() async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(
        AppearanceBlocInherited.of(navigatorKey.currentContext!)
            .appearance
            .isDarkMode);
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  static Future<void> setStatusBarColor(
      Color color, bool whiteForeground) async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(whiteForeground);
    await FlutterStatusbarcolor.setStatusBarColor(color);
  }

  static Future<void> hideKeyboard() async =>
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
}
