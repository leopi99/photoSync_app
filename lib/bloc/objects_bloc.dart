import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_sync/bloc/bloc_base.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/models/object_attributes.dart';
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
  // Repository
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
    Response? response;
    try {
      response = await _repository.getAll();
    } catch (e) {}

    if (response == null || response.statusCode != 200) {
      //TODO: show error to the user
      return;
    }
    //Converts the json into the objects
    addObjects(
      List.generate(
        response.data.length,
        (index) => Object.fromJSON(response!.data[index]),
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    _objectSubject.close();
  }
}