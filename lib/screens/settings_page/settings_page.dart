import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/app_bloc.dart';
import 'package:photo_sync/bloc/appearance_bloc.dart';
import 'package:photo_sync/constants/appearance.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/app_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/routes/route_builder.dart';
import 'package:photo_sync/util/enums/appearance_mode_type.dart';
import 'package:photo_sync/util/shared_manager.dart';
import 'package:photo_sync/widgets/sync_dialog.dart';
import 'package:photo_sync/widgets/sync_list_tile.dart';

class SettingsPage extends StatefulWidget {
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
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16)
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
          titleText: 'App appearance',
          trailing: DropdownButton<AppearanceModeType>(
            onChanged: (value) {
              if (value == null) return;
              appearanceBloc.changeAppearance(value);
              GlobalMethods.setStatusBarColorAsScaffoldBackground();
            },
            value: snapshot.data!.currentType,
            underline: Container(),
            icon: Icon(FeatherIcons.chevronDown),
            items: List.generate(
              AppearanceModeType.values.length,
              (index) => DropdownMenuItem(
                value: AppearanceModeType.values[index],
                child: Text(
                  AppearanceModeType.values[index].toValueWithSeparation,
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
        titleText: 'Logout',
        onTap: () async {
          await SyncDialog.show(
            context,
            title: 'Logout',
            content: 'Do you really want to logout?',
            primaryButtonOnPressed: () async => await SharedManager()
                .logout()
                .then((value) => AuthBlocInherited.of(context).logout(
                    context)), //Removes the saved credentials, then goes to the login page
            primaryButtonText: 'OK',
            secondaryButtonText: 'Cancel',
          );
        },
      ),
    );
  }

  Widget _buildChangePasswordTile() {
    return SyncListTile(
      titleText: 'Change password',
      onTap: () => Navigator.pushNamed(context, RouteBuilder.UPDATE_PROFILE),
    );
  }

  Widget _buildBackgroundSync() {
    return StreamBuilder<bool>(
      stream: appBloc.backgroundSyncStream,
      initialData: false,
      builder: (context, snapshot) {
        return SwitchListTile(
          title: Text('Background sync'),
          value: snapshot.data!,
          onChanged: (value) async => await appBloc.setBackgroundSync(value),
        );
      },
    );
  }
}
