import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';
import 'package:photo_sync/widgets/sync_elevated_button.dart';

class LoginPage extends StatefulWidget {
  final String username;
  final String password;

  LoginPage({
    required this.password,
    required this.username,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late AuthBloc authBloc;

  @override
  void initState() {
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    authBloc = AuthBlocInherited.of(navigatorKey.currentContext!);
    if (widget.username.isNotEmpty && widget.password.isNotEmpty) {
      authBloc.login(widget.username, widget.password);
    }
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      loadingStream: authBloc.loadingStream,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(hintText: 'Username'),
            ),
            SizedBox(height: 16),
            StreamBuilder<bool>(
                stream: authBloc.hidePassword,
                initialData: false,
                builder: (context, snapshot) {
                  return TextField(
                    controller: _passwordController,
                    obscureText: snapshot.data!,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () => authBloc.changeHidePassword(),
                        icon: Icon(snapshot.data!
                            ? FeatherIcons.eye
                            : FeatherIcons.eyeOff),
                      ),
                    ),
                  );
                }),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SyncElevatedButton(
                    onPressed: () async => await authBloc.login(
                        _usernameController.text, _passwordController.text),
                    buttonText: 'Login',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
