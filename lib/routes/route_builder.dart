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
  static const String SPLASH_SCREEN = "/";
  static const String HOMEPAGE = "/homepage";
  static const String ONBOARDING_PAGE = "/on_boarding";
  static const String SETTINGS_PAGE = "/settings_page";
  static const String LOGIN_PAGE = "/login";
  static const String SIGN_UP_PAGE = "/sign_up";
  static const String API_NOT_REACHABLE = "/api_not_reachable";
  static const String UPDATE_PROFILE = "/update_profile";
  static const String INITIAL_PAGE = SPLASH_SCREEN;

  static Route? generateRoute(RouteSettings settings) {
    String? path =
        settings.name!.startsWith('/') ? settings.name : '/' + settings.name!;

    print('Path: $path');

    switch (path) {
      case SPLASH_SCREEN:
        return _buildRoute(settings, path, SplashScreen());
      case HOMEPAGE:
        return _buildRoute(settings, path, SkeletonPage(initialPage: 0));
      case ONBOARDING_PAGE:
        return _buildRoute(settings, path, OnBoardingPage());
      case SETTINGS_PAGE:
        return _buildRoute(settings, path, SkeletonPage(initialPage: 1));
      case LOGIN_PAGE:
        Map<String, String> info = settings.arguments as Map<String, String>;
        return _buildRoute(
            settings,
            path,
            LoginPage(
              password: info['password'] ?? '',
              username: info['username'] ?? '',
            ));
      case SIGN_UP_PAGE:
        return _buildRoute(
            settings, path, SignUpPage(bloc: settings.arguments as AuthBloc));
      case UPDATE_PROFILE:
        return _buildRoute(settings, path, UpdateProfilePage());
      case API_NOT_REACHABLE:
        return _buildRoute(settings, path, ApiConnectionErrorPage());
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
