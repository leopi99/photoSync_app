import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/routes/route_builder.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late ObjectsBloc _objectsBloc;

  @override
  void initState() {
    _objectsBloc = ObjectsBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectsBlocInherited(
      bloc: _objectsBloc,
      child: MaterialApp(
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
      ),
    );
  }
}
