import 'package:flutter/material.dart';

//Handles the view of the loading

class BasePage extends StatelessWidget {
  final Stream<bool> loadingStream;
  final Widget child;

  BasePage({
    required this.child,
    required this.loadingStream,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: loadingStream,
        initialData: false,
        builder: (context, snapshot) => Stack(
          children: [
            if (snapshot.data!)
              Container(
                color: Colors.black26,
              ),
            child,
          ],
        ),
      ),
    );
  }
}
