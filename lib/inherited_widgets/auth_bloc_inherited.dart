import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';

class AuthBlocInherited extends InheritedWidget {
  AuthBlocInherited({
    required this.child,
    required this.bloc,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AuthBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthBlocInherited>()!.bloc;

  final Widget child;
  final AuthBloc bloc;
}
