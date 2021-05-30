import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/constants/assets_path.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/models/on_boarding_info.dart';
import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:photo_sync/util/shared_manager.dart';

const List<OnBoardingInfo> pages = [
  //The list of the pages to show in the onBoarding
  OnBoardingInfo(
    pageDescription:
        'Your files are saved in your own server, privacy is everything',
    localImageAssetPath: AssetsPath.onBoardingImage1,
  ),
  OnBoardingInfo(
    pageDescription: 'No storage limitations',
    localImageAssetPath: AssetsPath.onBoardingImage2,
  ),
  OnBoardingInfo(
    pageDescription: 'Relax while the app does all the work',
    localImageAssetPath: AssetsPath.onBoardingImage3,
  ),
];

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController _pageController;

  int currentPage = 0;

  @override
  void initState() {
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
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
    final double size = MediaQuery.of(context).size.width / 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          info.localImageAssetPath,
          height: size,
          width: size,
        ),
        if (info.pageDescription != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 32),
            child: Text(
              info.pageDescription!,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  void _goToHomepage() async {
    await SharedManager().writeBool(SharedType.OnBoardingDone, true);
    AppBloc.checkSession();
  }
}
