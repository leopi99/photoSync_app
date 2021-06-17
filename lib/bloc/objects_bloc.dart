import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/bloc/base/bloc_base.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/models/api_error.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/models/object_attributes.dart';
import 'package:photo_sync/models/raw_object.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/util/enums/object_type.dart';
import 'package:rxdart/rxdart.dart';

class ObjectsBloc extends BlocBase {
  ObjectsBloc() {
    _objectSubject = BehaviorSubject<List<Object>>.seeded([]);
    _repository = ObjectRepository();
  }

  //
  // Objects
  //
  List<Object> _objectsList = [];
  late BehaviorSubject<List<Object>> _objectSubject;

  Stream<List<Object>> get objectsStream => _objectSubject.stream;

  //
  // Api Repository
  //
  late ObjectRepository _repository;

  ///Adds a [List] of [Object] to the subject
  void addObjects(List<Object> objects, {bool reset = false}) {
    if (!reset)
      _objectsList.addAll(objects);
    else
      _objectsList = [];
    _objectSubject.add(UnmodifiableListView(_objectsList));
  }

  ///Retrieves the objects (pictures and videos) from the api
  Future<void> getObjectListFromApi() async {
    addObjects([]);
    await loadFromDisk();
    dynamic response;
    try {
      response = await _repository.getAll(
          AuthBlocInherited.of(navigatorKey.currentContext!)
              .currentUser!
              .userID
              .toString());
    } catch (e) {
      _showError(title: "Get object error");
      return;
    }

    //Error handling
    if (response == null) {
      _showError();
      return;
    }

    // Handles the api error (if there's one)
    ApiError? error;
    try {
      error = ApiError.fromJSON(response);
    } catch (e) {}

    if (error?.errorType != null) {
      _showError(title: error!.description);
      return;
    } else
      //Converts the json into the objects
      addObjects(
        List.generate(
          response.length,
          (index) => Object.fromJSON(response![index]),
        ),
      );
  }

  ///Loads the Recent folder
  Future<void> loadFromDisk() async {
    PermissionState state = await PhotoManager.requestPermissionExtend();
    if (state == PermissionState.authorized) {
      changeLoading(true);
      (await PhotoManager.getAssetPathList()).forEach(
        (element) async {
          //Only picks the Recent "folder"
          if (element.name == "Recent") {
            List<AssetEntity> assetList = await element.assetList;

            //Cycles the entities and creates the object
            for (int i = 0; i < assetList.length; i++) {
              if (assetList[i].type == AssetType.image ||
                  assetList[i].type == AssetType.video) {
                int bytes = (await assetList[i].file)!.statSync().size;
                File? file = await assetList[i].file;
                LatLng pos = await assetList[i].latlngAsync();
                ;
                addObjects(
                  [
                    Object(
                      futureFileBytes: assetList[i].file,
                      objectType: assetList[i].type == AssetType.image
                          ? ObjectType.Picture
                          : ObjectType.Video,
                      attributes: ObjectAttributes(
                        extension: '.${file!.path.split('.').last}',
                        isDownloaded: true,
                        creationDate: assetList[i]
                            .createDateTime
                            .millisecondsSinceEpoch
                            .toString(),
                        picturePosition: "${pos.latitude}, ${pos.longitude}",
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
      changeLoading(false);
    }
  }

  void changeObjectDownloadFlag(bool isDownloaded, int index) {
    _objectsList[index] = _objectsList[index].copyWith(
      attributes:
          _objectsList[index].attributes.copyWith(isDownloaded: isDownloaded),
    );
    _objectSubject.add(UnmodifiableListView(_objectsList));
  }

  ///Creates an image on the db => api
  Future<void> createPicture(RawObject object) async {
    dynamic response;
    try {
      response = await _repository.addObject(object);
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      _showError();
      return;
    }

    if (response == null || response is ApiError) {
      _showError();
      return;
    }

    //Adds the object to the list
    //TODO: uncomment when ready
    // addObjects([Object.fromJSON(response)]);
  }

  Future<void> checkNewObjectsAndBackup() async {
    changeLoading(true);
    List<RawObject> objects = [];
    await _recursiveAddRawObjects(
        _objectsList
            .where((element) => element.attributes.url?.isEmpty ?? true)
            .toList(),
        objects);
    await _uploadObjectRecursive(objects);
    changeLoading(false);
  }

  Future<void> _recursiveAddRawObjects(
      List<Object> objects, List<RawObject> raws) async {
    print(
        'recursiveAddRawObjects\tobjects: ${objects.length}\t raws:${raws.length}');
    try {
      Uint8List bytes =
          (await objects.first.futureFileBytes)!.readAsBytesSync();
      raws.add(RawObject(
          bytes: Int8List.fromList(bytes.toList()), object: objects.first));
    } catch (e, stacktrace) {
      print('Error: $e');
      print('StackTrace: $stacktrace');
      changeLoading(false);
      return;
    }
    if (objects.length - 1 > 0) {
      objects.removeAt(0);
      _recursiveAddRawObjects(objects, raws);
    }
  }

  Future<void> _uploadObjectRecursive(List<RawObject> objects) async {
    try {
      print('uploadObjectRecursive\tobjects: ${objects.length}');
      await createPicture(objects.first);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('StackTrace: $stacktrace');
      changeLoading(false);
      return;
    }
    if (objects.length - 1 > 0) {
      objects.removeAt(0);
      _uploadObjectRecursive(objects);
    }
  }

  void _showError({String title = "Error"}) {
    SnackBar _snack = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      action: SnackBarAction(
        label: 'close',
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(navigatorKey.currentContext!)
            .hideCurrentSnackBar(),
      ),
    );
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(_snack);
  }

  @override
  dispose() {
    super.dispose();
    _objectSubject.close();
  }
}
