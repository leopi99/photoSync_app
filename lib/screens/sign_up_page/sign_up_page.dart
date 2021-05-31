import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/auth_bloc.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';

class SignUpPage extends StatelessWidget {
  final AuthBloc bloc;

  SignUpPage({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BasePage(
      loadingStream: bloc.loadingStream,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(FeatherIcons.chevronLeft),
        ),
      ),
      child: Container(
        child: Center(
          child: Text('Register here'),
        ),
      ),
    );
  }
}
