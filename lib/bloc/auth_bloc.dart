import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/bloc/base/bloc_base.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
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

    try {
      changeLoading(true);
      data = await ObjectRepository().login(username, password);
    } catch (e) {
      print('Error $e');
      _showError(title: 'Login error');
      SharedManager().logout();
      changeLoading(false);
      return;
    }

    //Error handling, logout if the password was not changed from the app (TODO:)
    if (data == null || data['error'] != null) {
      changeLoading(false);
      SharedManager().logout();
      _showError(title: data['description'] ?? '');
      return;
    }

    //Updates the local user
    try {
      changeLoading(false);
      _currentUser = User.fromJSON(data);
    } catch (e) {
      print('Error $e');
      SharedManager().logout();
      _showError(title: data['description'] ?? '');
      return;
    }

    //Fetches the list of images
    ObjectsBlocInherited.of(navigatorKey.currentContext!)
        .getObjectListFromApi();

    //Saves the credentials
    await SharedManager().writeString(SharedType.LoginUsername, username);
    await SharedManager().writeString(SharedType.LoginPassword, password);
    changeLoading(false);
    //Checks the session, should go to the homepage
    await AppBloc.checkSession();
  }

  Future<void> register(String username, String password) async {
    if (password.isEmpty || username.isEmpty) {
      _showError(title: "Please, fill all the fields");
      return;
    }

    dynamic data;
    changeLoading(true);
    try {
      data = await ObjectRepository().register(username, password);
    } catch (e) {
      print('Error $e');
      _showError(title: 'Signup error');
      SharedManager().logout();
      changeLoading(false);
      return;
    }

    //Error handling, logout if the password was not changed from the app (TODO:)
    if (data == null || data['error'] != null) {
      changeLoading(false);
      _showError(title: data['description'] ?? '');
      return;
    }

    await login(username, password);
  }

  Future<void> changePassword(String newPassword) async {
    changeLoading(true);
    _currentUser = currentUser!.copyWith(password: newPassword);
    dynamic data;
    try {
      data = await ObjectRepository().updateProfile(_currentUser!);
    } catch (e, stacktrace) {
      print('Error $e');
      print('Stacktrace: $stacktrace');
      _showError();
      changeLoading(false);
      return;
    }

    //Error handling
    if (data == null || data['error'] != null) {
      changeLoading(false);
      _showError(title: data['description'] ?? '');
      return;
    }

    await SharedManager().writeString(SharedType.LoginPassword, newPassword);

    _showSuccess();

    changeLoading(false);
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

  void _showSuccess({String title = "Success"}) {
    SnackBar _snack = SnackBar(
      backgroundColor: Theme.of(navigatorKey.currentContext!).accentColor,
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

  ///User logout
  Future<void> logout(BuildContext context) async {
    await ObjectRepository().logout(_currentUser!.username);
    _currentUser = null;
    ObjectsBlocInherited.of(context).addObjects([], reset: true);
    AppBloc.checkSession();
  }

  @override
  dispose() {
    _hidePasswordSubject.close();
    super.dispose();
  }
}
