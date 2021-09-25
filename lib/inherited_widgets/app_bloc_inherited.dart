import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/app_bloc.dart';

class AppBlocInherited extends InheritedWidget {
  final AppBloc bloc;

  const AppBlocInherited({
    required this.bloc,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AppBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppBlocInherited>()!.bloc;
}
