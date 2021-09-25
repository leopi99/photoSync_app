import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';
import 'package:photo_sync/screens/api_connection_page/api_connection_page.dart';
import 'package:photo_sync/screens/login_page/login_page.dart';
import 'package:photo_sync/screens/on_boarding_page/on_boarding_page.dart';
import 'package:photo_sync/screens/sign_up_page/sign_up_page.dart';
import 'package:photo_sync/screens/skeleton_page/skeleton_page.dart';
import 'package:photo_sync/screens/splash_screen.dart';
import 'package:photo_sync/screens/update_profile_page/update_profile_page.dart';

///Handles the routes
class RouteBuilder {
  static const String splashScreen = "/";
  static const String homepage = "/homepage";
  static const String onBoardingPage = "/on_boarding";
  static const String settingsPage = "/settings_page";
  static const String loginPage = "/login";
  static const String signUpPage = "/sign_up";
  static const String apiNotReachable = "/api_not_reachable";
  static const String updateProfile = "/update_profile";
  static const String initialPage = splashScreen;

  static Route? generateRoute(RouteSettings settings) {
    String? path =
        settings.name!.startsWith('/') ? settings.name : '/' + settings.name!;

    debugPrint('Path: $path');

    switch (path) {
      case splashScreen:
        return _buildRoute(settings, path, const SplashScreen());
      case homepage:
        return _buildRoute(settings, path, const SkeletonPage(initialPage: 0));
      case onBoardingPage:
        return _buildRoute(settings, path, const OnBoardingPage());
      case settingsPage:
        return _buildRoute(settings, path, const SkeletonPage(initialPage: 1));
      case loginPage:
        Map<String, String> info = settings.arguments as Map<String, String>;
        return _buildRoute(
            settings,
            path,
            LoginPage(
              password: info['password'] ?? '',
              username: info['username'] ?? '',
            ));
      case signUpPage:
        return _buildRoute(
            settings, path, SignUpPage(bloc: settings.arguments as AuthBloc));
      case updateProfile:
        return _buildRoute(settings, path, const UpdateProfilePage());
      case apiNotReachable:
        return _buildRoute(settings, path, const ApiConnectionErrorPage());
      default:
        return null;
    }
  }

  static PageRoute _buildRoute(
      RouteSettings settings, String? path, Widget widget,
      {bool maintainState = true, bool fullscreenDialog = false}) {
    if (Platform.isAndroid) {
      return MaterialPageRoute(
          builder: (context) => widget,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog);
    }
    return CupertinoPageRoute(
        builder: (context) => widget,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog);
  }
}
