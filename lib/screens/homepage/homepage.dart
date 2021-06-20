import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';
import 'package:photo_sync/screens/homepage/grid_image.dart';
import 'package:photo_sync/util/enums/object_type.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  late ObjectsBloc bloc;

  @override
  void initState() {
    bloc = ObjectsBlocInherited.of(navigatorKey.currentContext!);
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifeCycle state: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        await bloc.loadFromDisk();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
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
    return BasePage(
      loadingStream: bloc.loadingStream,
      usePadding: true,
      floatingActionButton: _buildUploadPicturesFAB(),
      child: StreamBuilder<List<Object>>(
        stream: bloc.objectsStream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.data!.length == 0)
            return Center(
              child: Text('Nothing here'),
            );
          return GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemCount: snapshot.data!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              if (snapshot.data![index].objectType == ObjectType.Picture)
                return GridImage(snapshot.data![index], index);
              return Center(
                child: Text('Video not yet supported'),
              );
            },
          );
        },
      ),
    );
  }

  //This won't be present when I finish the background worker
  FloatingActionButton _buildUploadPicturesFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await bloc.checkNewObjectsAndBackup();
      },
      label: Text('Backup all objects'),
    );
  }
}
