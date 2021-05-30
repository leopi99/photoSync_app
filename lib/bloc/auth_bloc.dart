import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/bloc/bloc_base.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/api_error.dart';
import 'package:photo_sync/models/user.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:photo_sync/util/shared_manager.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase {
  AuthBloc() {
    _hidePasswordSubject = BehaviorSubject<bool>.seeded(true);
  }

  //
  //  CurrentUser
  //

  User? _currentUser;
  User? get currentUser => _currentUser;

  //
  //  Hide the password field text
  //

  late BehaviorSubject<bool> _hidePasswordSubject;
  Stream<bool> get hidePassword => _hidePasswordSubject.stream;
  void changeHidePassword() =>
      _hidePasswordSubject.add(!_hidePasswordSubject.value);

  ///Executes the login
  Future<void> login(String username, String password) async {
    await GlobalMethods.hideKeyboard();
    if (username.isEmpty || password.isEmpty) {
      _showError(title: 'Please, fill all the fields');
      return;
    }

    dynamic data;

    if (kDebugMode) {
      data = {
        'apiKey': 'thisIsTheTest',
        'username': 'leopi99',
        'email': 'pizio.leonardo@gmail.com'
      };
    } else
      try {
        changeLoading(true);
        data = await ObjectRepository().login(username, password);
      } catch (e) {
        print('Error $e');
        _showError(title: 'Login error');
        changeLoading(false);
        return;
      }

    if (data == null || data is ApiError) {
      changeLoading(false);
      _showError(title: 'Login error');
      return;
    }

    //Fetches the list of images
    await ObjectsBlocInherited.of(navigatorKey.currentContext!)
        .getObjectListFromApi();

    //Updates the user
    try {
      changeLoading(false);
      _currentUser = User.fromJSON(data);
    } catch (e) {
      print('Error $e');
      _showError(title: 'Login error');
      return;
    }

    await SharedManager().writeString(SharedType.LoginUsername, username);
    await SharedManager().writeString(SharedType.LoginPassword, password);
    changeLoading(false);
    //Checks the session, should go to the homepage
    await AppBloc.checkSession();
  }

  ///Shows the error snackBar
  void _showError({String title = "Error"}) {
    SnackBar _snack = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
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

  @override
  dispose() {
    _hidePasswordSubject.close();
    super.dispose();
  }
}
