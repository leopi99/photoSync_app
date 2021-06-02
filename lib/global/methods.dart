import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';

///Collection of static methods that does not depend on anything
class GlobalMethods {
  ///Sets the statusBar color as the scaffoldBackground, for the whiteForeground takes the darkMode
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
  ///Sets the statusBarColor as the dialog background color
  static Future<void> setStatusBarColorForDialog() async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(
        AppearanceBlocInherited.of(navigatorKey.currentContext!)
            .appearance
            .isDarkMode);
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  //Generic, sets the statusBarColor with the given color, as well as the whiteForeground
  static Future<void> setStatusBarColor(
      Color color, bool whiteForeground) async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(whiteForeground);
    await FlutterStatusbarcolor.setStatusBarColor(color);
  }

  ///Hides the keyboard
  static Future<void> hideKeyboard() async =>
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
}
