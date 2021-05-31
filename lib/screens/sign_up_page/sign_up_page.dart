import 'package:flutter/material.dart';
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
      child: Container(
        child: Center(
          child: Text('Register here'),
        ),
      ),
    );
  }
}
