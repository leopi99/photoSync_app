import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';
import 'package:photo_sync/inherited_widgets/objects_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/models/raw_object.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/screens/single_image_page/single_image_page.dart';
import 'package:photo_sync/extensions/date_time_extension.dart';
import 'package:photo_sync/widgets/sync_dialog.dart';
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
    return FutureBuilder<bool>(
      future: object.isDownloaded,
      initialData: false,
      builder: (context, isDownloaded) {
        return Stack(
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
              onLongPress: () =>
                  _imageBottomBar(object, context, isDownloaded.data!),
              child: Hero(
                tag: object.attributes.creationDate,
                child: FutureBuilder<dynamic>(
                  future: object.getFileBytes,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Container();
                    return Center(child: Image.memory(snapshot.data));
                  },
                ),
              ),
            ),
            if (!isDownloaded.data!)
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: DownloadIcon(
                  object: object,
                  objectIndex: objectIndex,
                ),
              ),
            if (object.attributes.syncDate == null)
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: UploadIcon(object: object),
              ),
          ],
        );
      },
    );
  }

  //Shows the modalBottomBar with some settings/text for the single image
  void _imageBottomBar(
      Object object, BuildContext context, bool downloaded) async {
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  downloaded
                      ? IconButton(
                          padding: EdgeInsets.all(16),
                          onPressed: () async {
                            bool isOk = false;
                            await SyncDialog.show(
                              context,
                              title: 'Really?',
                              content:
                                  'Do you really want to delete this file from the disk?',
                              primaryButtonOnPressed: () {
                                isOk = true;
                              },
                              primaryButtonText: 'I really want',
                              secondaryButtonOnPressed: () {},
                              secondaryButtonText: 'Cancel',
                            );
                            if (isOk) {
                              try {
                                await File(object.attributes.localPath)
                                    .delete();
                                await ObjectsBlocInherited.of(context)
                                    .getObjectListFromApi();
                              } catch (e) {
                                print(e);
                              }
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            FeatherIcons.trash2,
                            color: Theme.of(context).accentColor,
                          ),
                        )
                      : Container(),
                ],
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
                trailing:
                    Text(snapshot.data ?? object.attributes.picturePosition),
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
          await ObjectRepository().downloadObject(
              widget.object.attributes.creationDate +
                  widget.object.attributes.extension!,
              widget.object.attributes.localPath);
          await ObjectsBlocInherited.of(context).getObjectListFromApi();
        } catch (e, stacktrace) {
          print('Error while downloading or updating the object');
          print(e);
          print(stacktrace);
          setState(() {
            downloading = false;
          });
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

class UploadIcon extends StatefulWidget {
  final Object object;

  UploadIcon({
    required this.object,
  });

  @override
  _UploadIconState createState() => _UploadIconState();
}

class _UploadIconState extends State<UploadIcon> {
  late bool uploading;
  RawObject? rawObject;
  late ObjectsBloc bloc;

  @override
  void initState() {
    uploading = false;
    bloc = ObjectsBlocInherited.of(navigatorKey.currentContext!);
    _createRawObject();
    super.initState();
  }

  Future<void> _createRawObject() async {
    File? file = await widget.object.futureFileBytes!;
    if (file != null)
      rawObject = RawObject(
        object: widget.object,
        bytes: file.readAsBytesSync().buffer.asInt8List(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          uploading = true;
        });
        try {
          if (rawObject != null) await bloc.createPicture(rawObject!);
          await bloc.getObjectListFromApi();
        } catch (e, stacktrace) {
          print('Error while downloading or updating the object');
          print(e);
          print(stacktrace);
          setState(() {
            uploading = false;
          });
        }
        setState(() {
          uploading = false;
        });
      },
      child: Container(
        child: uploading
            ? CircularProgressIndicator()
            : Icon(FeatherIcons.uploadCloud),
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
