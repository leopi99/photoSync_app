import 'package:flutter/material.dart';

//Handles the view of the loading

class BasePage extends StatelessWidget {
  final Stream<bool> loadingStream;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool usePadding;

  BasePage({
    required this.child,
    required this.loadingStream,
    this.usePadding = false,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: usePadding ? MediaQuery.of(context).padding.top : 0),
      child: Scaffold(
        appBar: appBar,
        body: StreamBuilder<bool>(
          stream: loadingStream,
          initialData: false,
          builder: (context, snapshot) => Stack(
            children: [
              child,
              if (snapshot.data!)
                AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
