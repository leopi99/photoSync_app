import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/screens/homepage/homepage.dart';
import 'package:photo_sync/screens/splash_screen.dart';

class RouteBuilder {
  static const String SPLASH_SCREEN = "/";
  static const String HOMEPAGE = "/homepage";
  static const String INITIAl_PAGE = SPLASH_SCREEN;

  static Route? generateRoute(RouteSettings settings) {
    String? path =
        settings.name!.startsWith('/') ? settings.name : '/' + settings.name!;

    switch (path) {
      case SPLASH_SCREEN:
        return _buildRoute(settings, path, SplashScreen());
      case HOMEPAGE:
        return _buildRoute(settings, path, Homepage());
      default:
        return null;
    }
  }

  static PageRoute _buildRoute(
      RouteSettings settings, String? path, Widget widget,
      {bool maintainState = true, bool fullscreenDialog = false}) {
    if (Platform.isAndroid)
      return MaterialPageRoute(
          builder: (context) => widget,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog);
    return CupertinoPageRoute(
        builder: (context) => widget,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog);
  }
}
