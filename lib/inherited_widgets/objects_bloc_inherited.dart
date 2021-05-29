import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';

class ObjectsBlocInherited extends InheritedWidget {
  ObjectsBlocInherited({
    required this.bloc,
    required this.child,
  }) : super(child: child);

  final Widget child;
  final ObjectsBloc bloc;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static ObjectsBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ObjectsBlocInherited>()!.bloc;
}
