import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_sync/routes/route_builder.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _animationDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    Future.delayed(_animationDuration).then((_) => _onAnimationEnd());
  }

  //TODO: Create the animation (maybe with flare) or show the app icon.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          duration: _animationDuration,
        ),
      ),
    );
  }

  void _onAnimationEnd() =>
      Navigator.pushReplacementNamed(context, RouteBuilder.HOMEPAGE);
}
