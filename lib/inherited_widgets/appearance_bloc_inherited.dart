import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/appearance_bloc.dart';

class AppearanceBlocInherited extends InheritedWidget {
  final Widget child;
  final AppearanceBloc bloc;

  AppearanceBlocInherited({
    required this.bloc,
    required this.child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AppearanceBloc of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AppearanceBlocInherited>()!
      .bloc;
}
