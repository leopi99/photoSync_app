import 'package:flutter/material.dart';
import 'package:photo_sync/constants/assets_path.dart';
import 'package:photo_sync/models/on_boarding_info.dart';

class OnBoardingPage extends StatefulWidget {
  //The list of the pages to show in the onBoarding
  static const List<OnBoardingInfo> _pages = [
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

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController _pageController;

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
        itemCount: OnBoardingPage._pages.length,
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        pageSnapping: true,
        itemBuilder: (context, index) {
          return Center(
            child: _buildPage(OnBoardingPage._pages[index]),
          );
        },
      ),
      floatingActionButton: _pageController.page!.truncate() ==
              OnBoardingPage._pages.length - 1
          ? FloatingActionButton.extended(
              onPressed: () {
                _pageController.animateToPage(_pageController.page!.truncate(),
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInBack);
                //If the current page is the last, will update the ui to show the close button
                if (_pageController.page!.truncate() ==
                    OnBoardingPage._pages.length - 1) setState(() {});
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
        if (info.pageDescription != null) Text(info.pageDescription!),
      ],
    );
  }

  void _goToHomepage() {}
}
