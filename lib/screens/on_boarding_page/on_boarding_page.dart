import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/constants/assets_path.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
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
      body: Stack(
        children: [
          PageView.builder(
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
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 64),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    pages.length, (index) => _buildStepper(index)),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8, right: 8),
              child: currentPage < pages.length - 1
                  ? TextButton(
                      onPressed: () {
                        _pageController.animateToPage(currentPage + 1,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeInBack);
                        //If the current page is the last, will update the ui to show the close button
                        // if (currentPage == pages.length - 1)
                        setState(() {});
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : TextButton(
                      onPressed: _goToHomepage,
                      child: Text(
                        'Close',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ),
        ],
      ),
      // floatingActionButton: currentPage < pages.length - 1
      //     ? FloatingActionButton.extended(
      //         onPressed: () {
      //           _pageController.animateToPage(currentPage + 1,
      //               duration: Duration(milliseconds: 250),
      //               curve: Curves.easeInBack);
      //           //If the current page is the last, will update the ui to show the close button
      //           // if (currentPage == pages.length - 1)
      //           setState(() {});
      //         },
      //         label: Text('Next'),
      //       )
      //     : FloatingActionButton.extended(
      //         onPressed: _goToHomepage,
      //         label: Text('Close'),
      //       ),
    );
  }

  Widget _buildStepper(int index) {
    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: currentPage == index
            ? AppearanceBlocInherited.of(context)
                .appearance
                .currentThemeData
                .accentColor
            : Colors.grey[300],
        shape: BoxShape.circle,
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
