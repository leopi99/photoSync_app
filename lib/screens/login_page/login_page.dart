import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/widgets/sync_elevated_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late AuthBloc authBloc;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    authBloc = AuthBlocInherited.of(navigatorKey.currentContext!);
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
