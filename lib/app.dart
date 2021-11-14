import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/bloc/appearance_bloc.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/constants/appearance.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/app_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/routes/route_builder.dart';
import 'package:easy_localization/easy_localization.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late ObjectsBloc _objectsBloc;
  late AuthBloc _authBloc;
  late AppearanceBloc _appearanceBloc;
  late AppBloc _appBloc;

  @override
  void initState() {
    _objectsBloc = ObjectsBloc(getData: false);
    _authBloc = AuthBloc();
    _appearanceBloc = AppearanceBloc();
    _appBloc = AppBloc();
    ObjectRepository().setupDio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _createInheriteds(
      StreamBuilder<Appearance>(
        stream: _appearanceBloc.appearanceStream,
        initialData: Appearance(),
        builder: (context, snapshot) {
          return MaterialApp(
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            title: 'PhotoSync',
            theme: snapshot.data!.currentThemeData,
            home: WillPopScope(
              onWillPop: () async =>
                  !await navigatorKey.currentState!.maybePop(),
              child: LayoutBuilder(
                builder: (context, constraints) => Navigator(
                  key: navigatorKey,
                  initialRoute: RouteBuilder.initialPage,
                  observers: [
                    HeroController(),
                  ],
                  onGenerateRoute: RouteBuilder.generateRoute,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createInheriteds(Widget child) {
    return AppearanceBlocInherited(
      bloc: _appearanceBloc,
      child: AuthBlocInherited(
        bloc: _authBloc,
        child: ObjectsBlocInherited(
          bloc: _objectsBloc,
          child: AppBlocInherited(
            bloc: _appBloc,
            child: child,
          ),
        ),
      ),
    );
  }
}
