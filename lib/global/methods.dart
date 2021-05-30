import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:photo_sync/global/nav_key.dart';

class GlobalMethods {
  static Future<void> setStatusBarColorAsScaffoldBackground() async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    await FlutterStatusbarcolor.setStatusBarColor(
        Theme.of(navigatorKey.currentContext!).scaffoldBackgroundColor);
  }

  static Future<void> hideKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
