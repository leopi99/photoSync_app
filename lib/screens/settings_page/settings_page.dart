import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/appearance_bloc.dart';
import 'package:photo_sync/constants/appearance.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/util/enums/appearance_mode_type.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppearanceBloc appearanceBloc;

  @override
  void initState() {
    appearanceBloc = AppearanceBlocInherited.of(navigatorKey.currentContext!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildAppearanceTile(),
        ],
      ),
    );
  }

  Widget _buildAppearanceTile() {
    return StreamBuilder<Appearance>(
      stream: appearanceBloc.appearanceStream,
      initialData: Appearance(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('App appearance'),
          trailing: DropdownButton<AppearanceModeType>(
            onChanged: (value) =>
                value != null ? appearanceBloc.changeAppearance(value) : {},
            value: snapshot.data!.currentType,
            underline: Container(),icon: Icon(FeatherIcons.chevronDown),
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
}
