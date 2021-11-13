import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _kAnimationDuration = Duration(seconds: 2);

  late double opacity;

  @override
  void initState() {
    super.initState();
    GlobalMethods.hideKeyboard();
    opacity = 0;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        opacity = 1;
      });
    });
    Future.delayed(_kAnimationDuration).then((_) => AppBloc.checkSession());
  }

  //TODO: Create the animation (maybe with flare) or show the app icon.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.ease,
          opacity: opacity,
          child: FlutterLogo(
            size: MediaQuery.of(navigatorKey.currentContext!).size.width / 2,
            style: FlutterLogoStyle.markOnly,
          ),
        ),
      ),
    );
  }
}
