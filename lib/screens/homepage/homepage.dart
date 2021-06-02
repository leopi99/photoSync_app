import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';

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
    bloc.loadFromDisk();
    super.initState();
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
            itemBuilder: (context, index) => InkWell(
              onTap: () => _imageBottomBar(snapshot.data![index], context),
              child: snapshot.data![index].attributes.url.isEmpty
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
            ),
          );
        },
      ),
    );
  }

  void _imageBottomBar(Object object, BuildContext context) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                height: 4,
                width: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[400],
                ),
              ),
            ),
            ListTile(
              trailing: Text(object.attributes.pictureByteSize.toString()),
              title: Text(
                'File syze (MB)',
              ),
            ),
          ],
        );
      },
    );
  }
}
