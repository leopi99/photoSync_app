import 'package:flutter/material.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/routes/route_builder.dart';
import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:photo_sync/util/shared_manager.dart';

class AppBloc {
  Future<void> checkSession() async {
    bool onBoarding = await SharedManager().readBool(SharedType.OnBoardingDone);
    bool loginDone = await SharedManager().readBool(SharedType.LoginDone);
    //Goes to th onBoarding if not already done
    if (!onBoarding)
      Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, RouteBuilder.ONBOARDING_PAGE);

    if (!loginDone)
      Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, RouteBuilder.LOGIN_PAGE);

    //If nothing needs to be done goes to the homepage
    Navigator.pushReplacementNamed(
        navigatorKey.currentContext!, RouteBuilder.HOMEPAGE);
  }
}
