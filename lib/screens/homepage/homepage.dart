import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/models/object_attributes.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';
import 'package:photo_sync/util/enums/object_type.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late ObjectsBloc bloc;

  @override
  void initState() {
    bloc = ObjectsBlocInherited.of(navigatorKey.currentContext!);
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
    _cose();
    super.initState();
  }

  Future<void> _cose() async {
    print('Cose booted');
    PermissionState state = await PhotoManager.requestPermissionExtend();
    print('PermissionState: ${state.toString()}');
    // (await PhotoManager.getAssetPathList()).forEach((element) {
    //   print('name: ${element.name}\ncount: ${element.assetCount}\n');
    // });

    (await PhotoManager.getAssetPathList()).forEach(
      (element) async {
        if (element.name == "Recent") {
          List<AssetEntity> assetList = await element.assetList;

          for (int i = 0; i < assetList.length; i++) {
            if (assetList[i].type == AssetType.image ||
                assetList[i].type == AssetType.video) {
              int bytes = (await assetList[i].originBytes)!.length;
              print("relative path: ${assetList[i].relativePath!}");
              bloc.addObjects(
                [
                  Object(
                    fileBytes: assetList[i].file,
                    objectType: element.type == RequestType.image
                        ? ObjectType.Picture
                        : ObjectType.Video,
                    attributes: ObjectAttributes(
                      url: "",
                      syncDate: "",
                      creationDate:
                          assetList[i].modifiedDateTime.toIso8601String(),
                      username: 'leopi99',
                      picturePosition:
                          "${assetList[i].latitude} ${assetList[i].longitude}",
                      localPath: assetList[i].relativePath!,
                      pictureByteSize: bytes,
                      databaseID: 0,
                    ),
                  ),
                ],
              );
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      loadingStream: bloc.loadingStream,
      usePadding: true,
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
            itemBuilder: (context, index) =>
                snapshot.data![index].attributes.url.isEmpty
                    ? FutureBuilder<File?>(
                        future: snapshot.data![index].fileBytes!,
                        builder: (context, fileSnap) =>
                            fileSnap.hasData && fileSnap.data != null
                                ? Image.memory(
                                    fileSnap.data!.readAsBytesSync(),
                                    height: 128,
                                    width: 128,
                                  )
                                : Container(
                                    height: 128,
                                    width: 128,
                                  ),
                      )
                    : CachedNetworkImage(
                        imageUrl: snapshot.data![index].attributes.url,
                        httpHeaders: ObjectRepository().getHeaders,
                        height: 128,
                        width: 128,
                      ),
          );
        },
      ),
    );
  }
}
