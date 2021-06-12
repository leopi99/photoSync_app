import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';
import 'package:photo_sync/widgets/sync_elevated_button.dart';

class UpdateProfilePage extends StatefulWidget {
  UpdateProfilePage();

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late AuthBloc bloc;

  @override
  void initState() {
    bloc = AuthBlocInherited.of(navigatorKey.currentContext!);
    usernameController =
        TextEditingController(text: bloc.currentUser!.username);
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      loadingStream: bloc.loadingStream,
      appBar: AppBar(
        title: Text('Update profile'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(FeatherIcons.chevronLeft),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        children: [
          TextField(
            enabled: false,
            controller: usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SyncElevatedButton(
            padding: EdgeInsets.only(top: 16),
            buttonText: 'Update',
            onPressed: () async {
              await bloc.changePassword(passwordController.text);
            },
          ),
        ],
      ),
    );
  }
}
