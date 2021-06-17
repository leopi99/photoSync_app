import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/app_bloc.dart';

class AppBlocInherited extends InheritedWidget {
  final Widget child;
  final AppBloc bloc;

  AppBlocInherited({
    required this.bloc,
    required this.child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AppBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppBlocInherited>()!.bloc;
}
