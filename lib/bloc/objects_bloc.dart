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
import 'package:photo_sync/repository/interfaces/objects_repository_interface.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/util/enums/object_type.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_localization/easy_localization.dart';

class ObjectsBloc extends BlocBase {
  static const int _UPDATE_LOCAL_MEDIA_STEP = 20;
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

  ///To use for the "pagination" when loading media files
  int _localMediaPage = _UPDATE_LOCAL_MEDIA_STEP;

  //
  // Api Repository
  //
  late ObjectsRepositoryInterface _repository;

  ///Adds a [List] of [Object] to the subject
  ///
  ///Only if the localId is not present into the _objectsList
  void addObjects(List<Object> objects,
      {bool reset = false, bool updateState = true}) {
    if (reset) _objectsList = [];
    List<int> objAdds = [];
    for (int iSuper = 0; iSuper < objects.length; iSuper++) {
      bool canBeAdded = true;
      for (int i = 0; i < _objectsList.length; i++) {
        if (objects[iSuper].attributes.localID ==
            _objectsList[i].attributes.localID) {
          canBeAdded = false;
          break;
        }
      }
      if (canBeAdded) objAdds.add(iSuper);
    }
    for (int i = 0; i < objAdds.length; i++) {
      _objectsList.add(objects[i]);
    }
    if (updateState) _objectSubject.add(UnmodifiableListView(_objectsList));
  }

  ///Retrieves the objects (pictures and videos) from the api
  Future<void> getObjectListFromApi() async {
    List<Object> response;
    response = await _repository.getAll(_showError);
    addObjects([], reset: true, updateState: false);
    addObjects(response, updateState: false);
    await loadFromDisk();
  }

  Future<void> loadMoreFromDisk() async {
    _localMediaPage += _UPDATE_LOCAL_MEDIA_STEP;
    await loadFromDisk();
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
            int start = _localMediaPage - _UPDATE_LOCAL_MEDIA_STEP >= 0
                ? _localMediaPage - _UPDATE_LOCAL_MEDIA_STEP
                : 0;
            int end = _localMediaPage;
            if (assetList.length < end) end = assetList.length;
            //Cycles the entities and creates the objects
            await _recursivelyAddObject(
                assetList.sublist(start, end));
            _objectSubject.add(UnmodifiableListView(_objectsList));
            changeLoading(false);
          }
        },
      );
    }
  }

  ///Recursively adds objects from the local media [List<AssetEntity>]
  Future _recursivelyAddObject(List<AssetEntity> assetList) async {
    if (assetList.first.type == AssetType.image ||
        assetList.first.type == AssetType.video) {
      int bytes = (await assetList.first.file)!.statSync().size;
      File? file = await assetList.first.file;
      LatLng pos = await assetList.first.latlngAsync();
      addObjects(
        [
          Object(
            futureFileBytes: assetList.first.file,
            objectType: assetList.first.type == AssetType.image
                ? ObjectType.Picture
                : ObjectType.Video,
            attributes: ObjectAttributes(
              extension: '.${file!.path.split('.').last}',
              creationDate: assetList
                  .first.createDateTime.millisecondsSinceEpoch
                  .toString(),
              picturePosition: "${pos.latitude}, ${pos.longitude}",
              localPath: file.path,
              pictureByteSize: bytes,
              databaseID: 0,
              localID: int.parse(assetList.first.id),
            ),
          ),
        ],
        updateState: false,
      );
      assetList.removeAt(0);
    }
    if (assetList.length > 0) await _recursivelyAddObject(assetList);
  }

  ///Creates an image on the db => api
  Future<void> createPicture(RawObject object) async {
    dynamic response;
    try {
      object = RawObject(
        object: object.object.copyWith(
          attributes: object.object.attributes.copyWith(
            syncDate: DateTime.now().millisecondsSinceEpoch.toString(),
          ),
        ),
        bytes: object.bytes,
      );
      response = await _repository.addObject(
          object,
          int.parse(AuthBlocInherited.of(navigatorKey.currentContext!)
              .currentUser!
              .userID!));
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

  ///Checks the presence of new objects and uploads the found objects
  Future<void> checkNewObjectsAndBackup() async {
    changeLoading(true);
    List<RawObject> objects = [];
    //Creates a list of new objects (where the syncDate is not set)
    await _recursiveAddRawObjects(
        _objectsList
            .where((element) => element.attributes.syncDate?.isEmpty ?? true)
            .toList(),
        objects);
    if (objects.isNotEmpty) {
      await _uploadObjectRecursive(objects);
      await getObjectListFromApi();
    }
    changeLoading(false);
  }

  //Creates a list of RawObject from the list of Object passed
  Future<void> _recursiveAddRawObjects(
      List<Object> objects, List<RawObject> raws) async {
    if (objects.length == 0) {
      print('No need to upload media');
      return;
    }
    print(
        'recursiveAddRawObjects\tobjects: ${objects.length}\t rows:${raws.length}');
    if (objects.first.objectType ==
        ObjectType
            .Picture) //Only uploads the object if is a photo TODO: allow videos
      try {
        if (objects.first.futureFileBytes != null) {
          //Gets the bytes of the object
          Uint8List bytes =
              (await objects.first.futureFileBytes)!.readAsBytesSync();
          raws.add(RawObject(
              bytes: Int8List.fromList(bytes.toList()), object: objects.first));
        }
      } catch (e, stacktrace) {
        print('Error: $e');
        print('StackTrace: $stacktrace');
        print(
            'Error uploading file from ${objects.first.attributes.localPath}');
        changeLoading(false);
        // return;
      }
    //If the list is not empty, calls itself
    if (objects.length - 1 > 0) {
      objects.removeAt(0);
      _recursiveAddRawObjects(objects, raws);
    }
  }

  //Uploads the list of RawObject
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
    //If the list is not empty, calls itself
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
        label: 'close'.tr(),
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
