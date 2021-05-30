import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/constants/appearance.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/screens/homepage/homepage.dart';
import 'package:photo_sync/screens/settings_page/settings_page.dart';

class SkeletonPage extends StatefulWidget {
  final int initialPage;

  SkeletonPage({this.initialPage = 0});

  @override
  _SkeletonPageState createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  static const double _BAR_HEIGHT = 64;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildNavBar(),
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: _BAR_HEIGHT),
              child: PageView(
                controller: _controller,
                children: [
                  Homepage(),
                  SettingsPage(),
                ],
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: StreamBuilder<Appearance>(
        stream: AppearanceBlocInherited.of(context).appearanceStream,
        initialData: Appearance(),
        builder: (context, snapshot) {
          return Container(
            color: snapshot.data!.currentThemeData.scaffoldBackgroundColor,
            height: _BAR_HEIGHT,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => _controller.jumpToPage(0),
                  icon: Icon(FeatherIcons.home),
                ),
                IconButton(
                  onPressed: () => _controller.jumpToPage(1),
                  icon: Icon(FeatherIcons.settings),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
