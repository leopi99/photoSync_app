import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';
import 'package:photo_sync/screens/single_image_page/single_image_page.dart';
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
            itemBuilder: (context, index) =>
                snapshot.data![index].objectType == ObjectType.Picture
                    ? _buildImage(context, index, snapshot)
                    : Center(
                        child: Text('Video not yet supported'),
                      ),
          );
        },
      ),
    );
  }

  //Shows the modalBottomBar with some settings/text for the single image
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
              trailing: Text(filesize(object.attributes.pictureByteSize)),
              title: Text(
                'File size',
              ),
            ),
          ],
        );
      },
    );
  }

  //Builds the image widget
  Widget _buildImage(BuildContext context, int index,
          AsyncSnapshot<List<Object>> snapshot) =>
      snapshot.data![index].attributes.url.isEmpty
          ? FutureBuilder<File?>(
              future: snapshot.data![index].futureFileBytes!,
              builder: (context, fileSnap) => InkWell(
                onLongPress: () =>
                    _imageBottomBar(snapshot.data![index], context),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleImagePage(
                      object: snapshot.data![index],
                      image: fileSnap.data?.readAsBytesSync(),
                    ),
                  ),
                ),
                child: Hero(
                  tag: snapshot.data![index].attributes.url.isEmpty
                      ? snapshot.data![index].attributes.creationDate
                      : snapshot.data![index].attributes.url,
                  child: fileSnap.hasData && fileSnap.data != null
                      ? Image.memory(
                          fileSnap.data!.readAsBytesSync(),
                        )
                      : Container(),
                ),
              ),
            )
          : Stack(
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleImagePage(
                        object: snapshot.data![index],
                      ),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data![index].attributes.url,
                    httpHeaders: ObjectRepository().getHeaders,
                  ),
                ),
                if (!snapshot.data![index].attributes
                    .isDownloaded) //If the item is not downloaded, will show this "bage"
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Container(
                      child: Icon(FeatherIcons.downloadCloud),
                      padding: EdgeInsets.all(6),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppearanceBlocInherited.of(context)
                                .appearance
                                .isDarkMode
                            ? Colors.black54
                            : Colors.white54,
                      ),
                    ),
                  ),
              ],
            );
}
