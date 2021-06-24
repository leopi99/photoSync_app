import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:photo_sync/constants/appearance.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/screens/homepage/homepage.dart';
import 'package:photo_sync/screens/settings_page/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';

class SkeletonPage extends StatefulWidget {
  final int initialPage;

  SkeletonPage({this.initialPage: 0});

  @override
  _SkeletonPageState createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage>
    with WidgetsBindingObserver {
  static const double _BAR_HEIGHT = 64;
  late PageController _controller;
  static const double _NAV_ICONS_RADIUS = 48;
  int currentPage = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.initialPage);
    currentPage = widget.initialPage;
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifeCycle state: $state');
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
    switch (state) {
      case AppLifecycleState.resumed:
        await ObjectsBlocInherited.of(navigatorKey.currentContext!)
            .loadFromDisk();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
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
                onPageChanged: (value) => currentPage = value,
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

  ///Builds the page navbar
  Widget _buildNavBar() {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: StreamBuilder<Appearance>(
        stream: AppearanceBlocInherited.of(context).appearanceStream,
        initialData: Appearance(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GNav(
              haptic: false,
              tabBorderRadius: _NAV_ICONS_RADIUS,
              curve: Curves.linear,
              duration: Duration(milliseconds: 250),
              selectedIndex: currentPage,
              onTabChange: (value) => _controller.jumpToPage(value),
              gap: 8,
              tabBackgroundColor: snapshot.data!.isDarkMode
                  ? Colors.black45
                  : Colors.grey[350]!,
              activeColor: snapshot.data!.isDarkMode
                  ? Colors.white.withOpacity(.8)
                  : Colors.black,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              tabMargin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              tabs: [
                GButton(
                  icon: FeatherIcons.home,
                  text: 'home'.tr(),
                ),
                GButton(
                  icon: FeatherIcons.settings,
                  text: 'settings'.tr(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
