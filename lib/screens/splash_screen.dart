import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/routes/route_builder.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _animationDuration = Duration(seconds: 2);

  late double opacity;

  @override
  void initState() {
    super.initState();
    opacity = 0;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        opacity = 1;
      });
    });
    Future.delayed(_animationDuration).then((_) => _onAnimationEnd());
  }

  //TODO: Create the animation (maybe with flare) or show the app icon.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 1500),
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

  void _onAnimationEnd() =>
      Navigator.pushReplacementNamed(context, RouteBuilder.HOMEPAGE);
}
