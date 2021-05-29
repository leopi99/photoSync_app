import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_sync/routes/route_builder.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      Navigator.pushReplacementNamed(context, RouteBuilder.HOMEPAGE);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  //TODO: Create the animation (maybe with flare) or show the app icon.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('SPLASH'),
      ),
    );
  }
}
