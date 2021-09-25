import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';

class AuthBlocInherited extends InheritedWidget {
  final AuthBloc bloc;

  const AuthBlocInherited({
    required this.bloc,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AuthBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthBlocInherited>()!.bloc;
}
