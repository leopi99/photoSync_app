import 'dart:io';
import 'dart:typed_data';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
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
import 'package:easy_localization/easy_localization.dart';

class GridImage extends StatelessWidget {
  final Object object;
  final int objectIndex;
  Uint8List? imageBytes;

  GridImage(this.object, this.objectIndex, {Key? key}) : super(key: key);

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
                    image: imageBytes,
                  ),
                ),
              ),
              onLongPress: () =>
                  _imageBottomBar(object, context, isDownloaded.data!),
              child: Hero(
                tag: object.attributes.creationDate,
                child: FutureBuilder<Uint8List>(
                  future: object.getFileBytes,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Container();
                    imageBytes = snapshot.data;
                    return Center(
                        child: Image.memory(
                      snapshot.data!,
                      filterQuality: FilterQuality.low,
                    ));
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
    await showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
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
                  downloaded &&
                          (object.attributes.syncDate?.isNotEmpty ?? false)
                      ? IconButton(
                          padding: const EdgeInsets.all(16),
                          onPressed: () async {
                            bool isOk = false;
                            await SyncDialog.show(
                              context,
                              title: 'really?'.tr(),
                              content: 'deleteFileDescription'.tr(),
                              primaryButtonOnPressed: () {
                                isOk = true;
                              },
                              primaryButtonText: 'reallyWant'.tr(),
                              secondaryButtonOnPressed: () {},
                              secondaryButtonText: 'cancel'.tr(),
                            );
                            if (isOk) {
                              try {
                                await File(object.attributes.localPath)
                                    .delete();
                                await ObjectsBlocInherited.of(context)
                                    .getObjectListFromApi();
                              } catch (e) {
                                debugPrint('$e');
                              }
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            FeatherIcons.trash2,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            SyncListTile(
              trailing: Text(filesize(object.attributes.pictureByteSize)),
              titleText: 'fileSize'.tr(),
            ),
            FutureBuilder<String?>(
              future: object.attributes.positionFromCoordinates,
              initialData: '',
              builder: (context, snapshot) => SyncListTile(
                titleText: 'pictureShotAt'.tr(),
                trailing:
                    Text(snapshot.data ?? object.attributes.picturePosition),
              ),
            ),
            SyncListTile(
              titleText: 'pictureCreated'.tr(),
              trailing: Text(object.attributes.creationDateTime.toDayMonthYear),
            ),
            SyncListTile(
              titleText: 'syncDate'.tr(),
              trailing: Text(
                  object.attributes.syncronizationDateTime?.toDayMonthYear ??
                      'notYet'.tr()),
            ),
          ],
        );
      },
    );
  }
}

//Download icon on top of the web image.
class DownloadIcon extends StatefulWidget {
  final Object object;
  final int objectIndex;

  const DownloadIcon({
    required this.object,
    required this.objectIndex,
    Key? key,
  }) : super(key: key);

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
          debugPrint('Error while downloading or updating the object');
          debugPrint('$e');
          debugPrint('$stacktrace');
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
            ? const CircularProgressIndicator()
            : const Icon(FeatherIcons.downloadCloud),
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(8),
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

  const UploadIcon({
    required this.object,
    Key? key,
  }) : super(key: key);

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
    if (file != null) {
      rawObject = RawObject(
        object: widget.object,
        bytes: file.readAsBytesSync().buffer.asInt8List(),
      );
    }
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
          debugPrint('Error while downloading or updating the object');
          debugPrint('$e');
          debugPrint('$stacktrace');
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
            ? const CircularProgressIndicator()
            : const Icon(FeatherIcons.uploadCloud),
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(8),
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
