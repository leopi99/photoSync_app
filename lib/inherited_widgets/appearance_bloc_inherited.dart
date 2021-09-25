import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/appearance_bloc.dart';

class AppearanceBlocInherited extends InheritedWidget {
  final AppearanceBloc bloc;

  const AppearanceBlocInherited({
    required this.bloc,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AppearanceBloc of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AppearanceBlocInherited>()!
      .bloc;
}
