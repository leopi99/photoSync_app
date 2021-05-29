import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/routes/route_builder.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late ObjectsBloc _objectsBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    _objectsBloc = ObjectsBloc();
    _authBloc = AuthBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBlocInherited(
      bloc: _authBloc,
      child: ObjectsBlocInherited(
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
      ),
    );
  }
}
