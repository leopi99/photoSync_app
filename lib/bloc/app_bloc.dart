import 'package:flutter/material.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/routes/route_builder.dart';
import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:photo_sync/util/shared_manager.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  late BehaviorSubject<bool> _backgroundSyncSubject;
  Stream<bool> get backgroundSyncStream => _backgroundSyncSubject.stream;

  AppBloc() {
    _backgroundSyncSubject = BehaviorSubject.seeded(false);
    readBackgroundSync();
  }

  //Checks the "session", changes the current page
  static Future<void> checkSession() async {
    bool onBoarding = await SharedManager().readBool(SharedType.OnBoardingDone);

    String? username =
        await SharedManager().readString(SharedType.LoginUsername);
    String? password =
        await SharedManager().readString(SharedType.LoginPassword);

    //Goes to the onBoarding if not already done
    if (!onBoarding) {
      Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, RouteBuilder.ONBOARDING_PAGE);
      return;
    }
    if (AuthBlocInherited.of(navigatorKey.currentContext!).currentUser ==
        null) {
      Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, RouteBuilder.LOGIN_PAGE,
          arguments: {'username': username ?? '', 'password': password ?? ''});
      return;
    }
    //If nothing needs to be done, goes to the homepage
    Navigator.pushReplacementNamed(
        navigatorKey.currentContext!, RouteBuilder.HOMEPAGE);
  }

  Future<void> setBackgroundSync(bool value) async {
    await SharedManager().writeBool(SharedType.BackgroundBackup, value);
    _backgroundSyncSubject.add(value);
  }

  Future<bool> readBackgroundSync() async {
    bool value = await SharedManager().readBool(SharedType.BackgroundBackup);
    _backgroundSyncSubject.add(value);
    return value;
  }
}
