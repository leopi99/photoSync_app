import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';
import 'package:photo_sync/screens/homepage/grid_image.dart';
import 'package:photo_sync/util/enums/object_type.dart';
import 'package:easy_localization/easy_localization.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin {
  late ObjectsBloc bloc;
  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    bloc = ObjectsBlocInherited.of(navigatorKey.currentContext!);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 10) bloc.loadMoreFromDisk();
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      loadingStream: bloc.loadingStream,
      usePadding: true,
      floatingActionButton: _buildUploadPicturesFAB(),
      child: StreamBuilder<List<Object>>(
        stream: bloc.objectsStream,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text('nothingHere'.tr()),
            );
          }
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            controller: _scrollController,
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              if (snapshot.data![index].objectType == ObjectType.picture) {
                return GridImage(snapshot.data![index], index);
              }
              return const Center(
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
      label: Text('backupAllObjects'.tr()),
    );
  }
}
