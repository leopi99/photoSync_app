import 'package:flutter/material.dart';
import 'package:photo_sync/constants/assets_path.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/models/on_boarding_info.dart';
import 'package:photo_sync/routes/route_builder.dart';
import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:photo_sync/util/shared_manager.dart';

const List<OnBoardingInfo> pages = [
  OnBoardingInfo(
    pageDescription: 'Free backup utils',
    localImageAssetPath: AssetsPath.onBoardingImage1,
  ),
  OnBoardingInfo(
    pageDescription: 'No storage limitations',
    localImageAssetPath: AssetsPath.onBoardingImage2,
  ),
  OnBoardingInfo(
    localImageAssetPath: AssetsPath.onBoardingImage3,
  ),
];

class OnBoardingPage extends StatefulWidget {
  //The list of the pages to show in the onBoarding

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController _pageController;

  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        onPageChanged: (value) => setState(() {
          currentPage = value;
        }),
        itemCount: pages.length,
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        pageSnapping: true,
        itemBuilder: (context, index) {
          return Center(
            child: _buildPage(pages[index]),
          );
        },
      ),
      floatingActionButton: currentPage < pages.length - 1
          ? FloatingActionButton.extended(
              onPressed: () {
                _pageController.animateToPage(currentPage + 1,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInBack);
                //If the current page is the last, will update the ui to show the close button
                if (currentPage == pages.length - 1) setState(() {});
              },
              label: Text('Next'),
            )
          : FloatingActionButton.extended(
              onPressed: _goToHomepage,
              label: Text('Close'),
            ),
    );
  }

  Widget _buildPage(OnBoardingInfo info) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          info.localImageAssetPath,
          height: 256,
          width: 256,
        ),
        if (info.pageDescription != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              info.pageDescription!,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  void _goToHomepage() async {
    await SharedManager().writeBool(SharedType.OnBoardingDone, true);
    Navigator.pushReplacementNamed(
        navigatorKey.currentContext!, RouteBuilder.HOMEPAGE);
  }
}
