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
  ///
  ///Only if the localId is not present into the _objectsList
  void addObjects(List<Object> objects, {bool reset = false}) {
    if (!reset) {
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
    } else
      _objectsList = [];
    _objectSubject.add(UnmodifiableListView(_objectsList));
  }

  ///Retrieves the objects (pictures and videos) from the api
  Future<void> getObjectListFromApi() async {
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
    } else {
      addObjects([], reset: true);
      //Converts the json into the objects
      addObjects(
        List.generate(
          response.length,
          (index) => Object.fromJSON(response![index]),
        ),
      );
    }

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

            //Cycles the entities and creates the object
            for (int i = 0; i < assetList.length; i++) {
              if (assetList[i].type == AssetType.image ||
                  assetList[i].type == AssetType.video) {
                int bytes = (await assetList[i].file)!.statSync().size;
                File? file = await assetList[i].file;
                LatLng pos = await assetList[i].latlngAsync();
                addObjects(
                  [
                    Object(
                      futureFileBytes: assetList[i].file,
                      objectType: assetList[i].type == AssetType.image
                          ? ObjectType.Picture
                          : ObjectType.Video,
                      attributes: ObjectAttributes(
                          extension: '.${file!.path.split('.').last}',
                          creationDate: assetList[i]
                              .createDateTime
                              .millisecondsSinceEpoch
                              .toString(),
                          picturePosition: "${pos.latitude}, ${pos.longitude}",
                          localPath: file.path,
                          pictureByteSize: bytes,
                          databaseID: 0,
                          localID: int.parse(assetList[i].id)),
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
    print(
        'recursiveAddRawObjects\tobjects: ${objects.length}\t rows:${raws.length}');
    try {
      //Gets the bytes of the object
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
