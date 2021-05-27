import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:rxdart/rxdart.dart';

class ObjectsBloc {
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
}
