import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/bloc/appearance_bloc.dart';
import 'package:photo_sync/constants/appearance.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/app_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/routes/route_builder.dart';
import 'package:photo_sync/util/enums/appearance_mode_type.dart';
import 'package:photo_sync/util/shared_manager.dart';
import 'package:photo_sync/widgets/sync_dialog.dart';
import 'package:photo_sync/widgets/sync_list_tile.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppearanceBloc appearanceBloc;
  late AppBloc appBloc;

  @override
  void initState() {
    appearanceBloc = AppearanceBlocInherited.of(navigatorKey.currentContext!);
    appBloc = AppBlocInherited.of(navigatorKey.currentContext!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16)
            .copyWith(top: MediaQuery.of(context).padding.top + 8),
        children: [
          _buildBackgroundSync(),
          _buildChangePasswordTile(),
          _buildAppearanceTile(),
          _buildLogoutTile(),
        ],
      ),
    );
  }

  ///Builds the appearance selector (darkMode/lightMode/FollowSystem) => [AppearanceModeType]
  Widget _buildAppearanceTile() {
    return StreamBuilder<Appearance>(
      stream: appearanceBloc.appearanceStream,
      initialData: Appearance(),
      builder: (context, snapshot) {
        return SyncListTile(
          titleText: 'appAppearance'.tr(),
          trailing: DropdownButton<AppearanceModeType>(
            onChanged: (value) {
              if (value == null) return;
              appearanceBloc.changeAppearance(value);
            },
            value: snapshot.data!.currentType,
            underline: Container(),
            icon: const Icon(FeatherIcons.chevronDown),
            items: List.generate(
              AppearanceModeType.values.length,
              (index) => DropdownMenuItem(
                value: AppearanceModeType.values[index],
                child: Text(
                  AppearanceModeType.values[index].toValue.tr(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //Builds the logout tile
  Widget _buildLogoutTile() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SyncListTile(
        titleText: 'logout'.tr(),
        onTap: () async {
          await SyncDialog.show(
            context,
            title: 'logout'.tr(),
            content: 'logoutDescription'.tr(),
            primaryButtonOnPressed: () async => await SharedManager()
                .logout()
                .then((value) => AuthBlocInherited.of(context).logout(context)),
            //Removes the saved credentials, then goes to the login page
            primaryButtonText: 'ok'.tr(),
            secondaryButtonText: 'cancel'.tr(),
          );
        },
      ),
    );
  }

  //Builds the change password tile, opens the page
  Widget _buildChangePasswordTile() {
    return SyncListTile(
      titleText: 'changePassword'.tr(),
      onTap: () => Navigator.pushNamed(context, RouteBuilder.updateProfile),
    );
  }

  //Builds the backgroundSync switch tile
  Widget _buildBackgroundSync() {
    return StreamBuilder<bool>(
      stream: appBloc.backgroundSyncStream,
      initialData: false,
      builder: (context, snapshot) {
        return SyncListTile(
          titleText: 'backgroundSync'.tr(),
          onTap: () {},
          trailing: Switch(
            value: snapshot.data!,
            onChanged: (value) async => await appBloc.setBackgroundSync(value),
          ),
        );
      },
    );
  }
}
