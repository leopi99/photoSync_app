import 'package:flutter/material.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/routes/route_builder.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
        child: LayoutBuilder(
          builder: (context, constraints) => Navigator(
            key: navigatorKey,
            initialRoute: RouteBuilder.INITIAl_PAGE,
            observers: [
              HeroController(),
            ],
            onGenerateRoute: RouteBuilder.generateRoute,
          ),
        ),
      ),
    );
  }
}
