import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';
import 'package:photo_sync/widgets/sync_elevated_button.dart';

class SignUpPage extends StatelessWidget {
  final AuthBloc bloc;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpPage({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BasePage(
      loadingStream: bloc.loadingStream,
      appBar: AppBar(
        title: Text('Sign up'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            await GlobalMethods.hideKeyboard();
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.chevronLeft),
        ),
      ),
      child: Padding(
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
              stream: bloc.hidePassword,
              initialData: false,
              builder: (context, snapshot) {
                return TextField(
                  controller: _passwordController,
                  obscureText: snapshot.data!,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () => bloc.changeHidePassword(),
                      icon: Icon(snapshot.data!
                          ? FeatherIcons.eye
                          : FeatherIcons.eyeOff),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SyncElevatedButton(
                    onPressed: () async => bloc.register(_usernameController.text, _passwordController.text),
                    buttonText: 'Register',
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
