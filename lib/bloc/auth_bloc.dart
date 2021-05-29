import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/api_error.dart';
import 'package:photo_sync/models/user.dart';
import 'package:photo_sync/repository/object_repository.dart';

class AuthBloc {
  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> login(String username, String password) async {
    dynamic data;
    try {
      data = await ObjectRepository().login(username, password);
    } catch (e) {
      print('Error $e');
      return;
    }

    if (data == null || data is ApiError) {
      _showError(title: 'Login error');
      return;
    }

    //Fetches the list of images
    await ObjectsBlocInherited.of(navigatorKey.currentContext!)
        .getObjectListFromApi();

    //Updates the user
    _currentUser = User.fromJSON(data);

    //Checks the session, should go to the homepage
    await AppBloc().checkSession();
  }

  void _showError({String title = "Error"}) {
    SnackBar _snack = SnackBar(
      backgroundColor: Colors.red,
      content: Text(title),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      action: SnackBarAction(
        label: 'close',
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(navigatorKey.currentContext!)
            .hideCurrentSnackBar(),
      ),
    );
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(_snack);
  }
}
