import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/bloc/bloc_base.dart';
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
    if (kDebugMode) {
      addObjects(
        [
          Object(
            objectType: ObjectType.Picture,
            attributes: ObjectAttributes(
              url: 'https://avatars.githubusercontent.com/u/51258212?v=4',
              syncDate: '',
              creationDate: DateTime.now().toIso8601String(),
              username: AuthBlocInherited.of(navigatorKey.currentContext!)
                  .currentUser!
                  .username,
              picturePosition: '',
              localPath: '',
              pictureByteSize: 1504561,
              databaseID: 0,
              isDownloaded: false,
            ),
          ),
        ],
      );
      return;
    }
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
                print("relative path: ${assetList[i].relativePath!}");
                addObjects(
                  [
                    Object(
                      fileBytes: assetList[i].file,
                      objectType: assetList[i].type == AssetType.image
                          ? ObjectType.Picture
                          : ObjectType.Video,
                      attributes: ObjectAttributes(
                        isDownloaded: true,
                        url: "",
                        syncDate: "",
                        creationDate:
                            assetList[i].modifiedDateTime.toIso8601String(),
                        username:
                            AuthBlocInherited.of(navigatorKey.currentContext!)
                                .currentUser!
                                .username,
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
      changeLoading(false);
    }
  }

  ///Creates an image on the db => api
  ///TODO: Complete the code when the api handles the addPicture
  Future<void> createPicture(RawObject object) async {
    dynamic response;
    try {
      response = await _repository.addPicture(object);
    } catch (e) {
      _showError();
      return;
    }

    if (response == null || response is ApiError) {
      _showError();
      return;
    }

    //Adds the object to the list
    addObjects([Object.fromJSON(response)]);
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
