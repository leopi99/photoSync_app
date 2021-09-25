import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';

class ObjectsBlocInherited extends InheritedWidget {
  final ObjectsBloc bloc;

  const ObjectsBlocInherited({
    required this.bloc,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static ObjectsBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ObjectsBlocInherited>()!.bloc;
}
