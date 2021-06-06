import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/screens/single_image_page/single_image_page.dart';

class GridImage extends StatelessWidget {
  final Object object;
  final int objectIndex;

  GridImage(
    this.object,
    this.objectIndex,
  );

  @override
  Widget build(BuildContext context) {
    return object.attributes.url.isEmpty
        ? FutureBuilder<File?>(
            future: object.futureFileBytes!,
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
                tag: object.attributes.url.isEmpty
                    ? object.attributes.creationDate
                    : object.attributes.url,
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
                child: CachedNetworkImage(
                  imageUrl: object.attributes.url,
                  httpHeaders: ObjectRepository().getHeaders,
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
                              url: object.attributes.url,
                              localPath: object.attributes.localPath,
                              objectIndex: objectIndex,
                            ),
                          )
                        : Container(),
              ),
            ],
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
}

class DownloadIcon extends StatefulWidget {
  final String url;
  final String localPath;
  final int objectIndex;

  DownloadIcon({
    required this.url,
    required this.localPath,
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
          await ObjectRepository().downloadObject(widget.url, widget.localPath);
          ObjectsBlocInherited.of(context)
              .changeObjectDownloadFlag(true, widget.objectIndex);
        } catch (e) {}
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
