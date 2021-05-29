import 'package:flutter/material.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/routes/route_builder.dart';
import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:photo_sync/util/shared_manager.dart';

class AppBloc {
  Future<void> checkSession() async {
    bool onBoarding = await SharedManager().readBool(SharedType.OnBoardingDone);
    if (!onBoarding)
      Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, RouteBuilder.ONBOARDING_PAGE);
  }
}
