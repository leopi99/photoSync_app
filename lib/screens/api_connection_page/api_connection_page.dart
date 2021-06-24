import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_sync/constants/assets_path.dart';
import 'package:easy_localization/easy_localization.dart';

///Tells the user that the server is not reachable
class ApiConnectionErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width - 64;
    return Scaffold(
      appBar: AppBar(
        title: Text('ApiError'.tr()),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(FeatherIcons.chevronLeft),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetsPath.notReachableApi,
                height: size,
                width: size,
              ),
              SizedBox(height: 32),
              Text(
                'apiNotReachableDescription'.tr(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
