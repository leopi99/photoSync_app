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
        Theme.of(navigatorKey.currentContext!).scaffoldBackgroundColor);
  }

  static Future<void> hideKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
