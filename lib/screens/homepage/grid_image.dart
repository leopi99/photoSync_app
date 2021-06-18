import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/screens/single_image_page/single_image_page.dart';
import 'package:photo_sync/extensions/date_time_extension.dart';
import 'package:photo_sync/widgets/sync_list_tile.dart';

class GridImage extends StatelessWidget {
  final Object object;
  final int objectIndex;

  GridImage(
    this.object,
    this.objectIndex,
  );

  @override
  Widget build(BuildContext context) {
    return object.attributes.isDownloaded
        ? FutureBuilder<File?>(
            future: object.futureFileBytes ??
                Future.value(File(object.attributes.localPath)),
            builder: (context, fileSnap) => InkWell(
              onLongPress: () => _imageBottomBar(object, context),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleImagePage(
                    object: object,
                    image: fileSnap.data?.readAsBytesSync(),
                  ),
                ),
              ),
              child: Hero(
                tag: object.attributes.creationDate,
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
                      object: object,
                    ),
                  ),
                ),
                child: Hero(
                  tag: object.attributes.creationDate,
                  child: CachedNetworkImage(
                    imageUrl: object.attributes.url!,
                    httpHeaders: ObjectRepository().getHeaders,
                  ),
                ),
              ),
              FutureBuilder<bool>(
                future: object.isDownloaded,
                initialData: false,
                builder: (context, downloadedSnapshot) =>
                    !downloadedSnapshot.data!
                        ? Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: DownloadIcon(
                              object: object,
                              objectIndex: objectIndex,
                            ),
                          )
                        : Container(),
              ),
            ],
          );
  }

  //Shows the modalBottomBar with some settings/text for the single image
  void _imageBottomBar(Object object, BuildContext context) async {
    await GlobalMethods.setStatusBarColorForDialog();
    await showModalBottomSheet(
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
            SyncListTile(
              trailing: Text(filesize(object.attributes.pictureByteSize)),
              titleText: 'File size',
            ),
            FutureBuilder<String?>(
              future: object.attributes.positionFromCoordinates,
              initialData: '',
              builder: (context, snapshot) => SyncListTile(
                titleText: 'Picture shot at',
                trailing: Text(snapshot.data ?? object.attributes.picturePosition),
              ),
            ),
            SyncListTile(
              titleText: 'Picture created',
              trailing: Text(object.attributes.creationDateTime.toDayMonthYear),
            ),
            SyncListTile(
              titleText: 'Syncronization date',
              trailing: Text(
                  object.attributes.syncronizationDateTime?.toDayMonthYear ??
                      'Not yet'),
            ),
          ],
        );
      },
    );
    await GlobalMethods.setStatusBarColorAsScaffoldBackground();
  }
}

//Download icon on top of the web image.
class DownloadIcon extends StatefulWidget {
  final Object object;
  final int objectIndex;

  DownloadIcon({
    required this.object,
    required this.objectIndex,
  });

  @override
  _DownloadIconState createState() => _DownloadIconState();
}

class _DownloadIconState extends State<DownloadIcon> {
  late bool downloading;

  @override
  initState() {
    super.initState();
    downloading = false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          downloading = true;
        });
        try {
          await ObjectRepository().downloadObject(widget.object.attributes.url!,
              widget.object.attributes.localPath);
          ObjectsBlocInherited.of(context)
              .changeObjectDownloadFlag(true, widget.objectIndex);
          await ObjectRepository().updateDownloadedObject(
              "${widget.object.attributes.databaseID}", true);
        } catch (e, stacktrace) {
          print('Error while downloading or updating the object');
          print(e);
          print(stacktrace);
        }
        setState(() {
          downloading = false;
        });
      },
      child: Container(
        child: downloading
            ? CircularProgressIndicator()
            : Icon(FeatherIcons.downloadCloud),
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppearanceBlocInherited.of(context).appearance.isDarkMode
              ? Colors.black54
              : Colors.white54,
        ),
      ),
    );
  }
}
