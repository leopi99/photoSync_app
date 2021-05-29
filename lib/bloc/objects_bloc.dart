import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/bloc_base.dart';
import 'package:photo_sync/global/nav_key.dart';
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
    _repository = ObjectRepository()..setupDio();
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

  void addObjects(List<Object> objects) {
    _objectsList.addAll(objects);
    _objectSubject.add(UnmodifiableListView(_objectsList));
  }

  ///Retrieves the objects (pictures and videos) from the api
  Future<void> getObjectListFromApi() async {
    if (kDebugMode) {
      addObjects([
        Object(
          objectType: ObjectType.Picture,
          attributes: ObjectAttributes(
            url: '',
            syncDate: DateTime.now().toIso8601String(),
            creationDate: DateTime.now().toIso8601String(),
            username: 'leopi99',
            picturePosition: 'Italy',
            localPath: '',
            pictureByteSize: 19000,
            databaseID: 1,
          ),
        ),
      ]);
      return;
    }
    dynamic response;
    try {
      response = await _repository.getAll();
    } catch (e) {}

    if (response == null || response is ApiError) {
      //TODO: show error to the user
      _showError();
      return;
    }
    //Converts the json into the objects
    addObjects(
      List.generate(
        response.length,
        (index) => Object.fromJSON(response![index]),
      ),
    );
  }

  ///Creates an image on the db => api
  Future<void> createPicture(RawObject object) async {
    dynamic response;
    try {
      response = await _repository.addPicture(object);
    } catch (e) {
      //TODO: Handle the error
      _showError();
      return;
    }

    if (response == null || response is ApiError) {
      //TODO: Handle the error
      _showError();
      return;
    }

    //Adds the object to the list
    addObjects([Object.fromJSON(response)]);
  }

  void _showError({String title = "Error"}) {
    SnackBar _snack = SnackBar(
      backgroundColor: Colors.red,
      content: Text(title),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'close',
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
