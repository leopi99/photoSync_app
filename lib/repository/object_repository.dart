import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_sync/models/raw_object.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/models/user.dart';
import 'package:photo_sync/repository/interfaces/objects_repository_interface.dart';
import 'package:photo_sync/util/api_connection_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ObjectRepository extends ObjectsRepositoryInterface {
  static const _host =
      "http://192.168.1.7"; //This address works in the android emulator => change to the ip address where you host the api (with the api in localhost)
  static const _port = ":8010"; //Port dedicated to the api
  static const _apiPath = "$_host$_port/photoSync/api/v1";

  static get apiPath => _apiPath;

  String? _authKey;

  Dio? _dioInstance;

  static final ObjectRepository _singleton = ObjectRepository._internal();

  factory ObjectRepository() {
    return _singleton;
  }

  ObjectRepository._internal();

  ///Creates the dio instance, if already present, sets the headers
  void setupDio() {
    debugPrint('ApiPath: $_apiPath');
    if (_dioInstance == null) {
      BaseOptions _dioOptions = BaseOptions(
        baseUrl: _apiPath,
        connectTimeout: 10800,
        validateStatus: (_) => true,
        responseType: ResponseType.json,
      );
      _dioInstance = Dio(_dioOptions);
      //Adds the Logger for request-reponse to Dio
      _dioInstance!.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
      //If the error (of a request) is ConnectionTimeOut => Tells the user that the api are not reachable
      _dioInstance!.interceptors.add(ApiConnectionInterceptor());
      return;
    }
  }

  Map<String, String> get getHeaders =>
      {'apiKey': _dioInstance!.options.headers['apiKey']};

  @override
  Future<List<Object>> getAll(Function({String title}) errorCallBack) async {
    Response response = await _dioInstance!.get('/getAll').onError(
        (error, stackTrace) => errorCallBack(title: "Get objects error"));
    return _convertJsonListToObject(response.data);
  }

  @override
  Future<List<Object>> getPictures(
      Function({String title}) errorCallBack) async {
    Response response = await _dioInstance!.get('/getPictures').onError(
        (error, stackTrace) => errorCallBack(title: "Get pictures error"));
    return _convertJsonListToObject(response.data);
  }

  @override
  Future<List<Object>> getVideos(Function({String title}) errorCallBack) async {
    Response response = await _dioInstance!.get('/getVideos').onError(
        (error, stackTrace) => errorCallBack(title: "Get videos error"));
    return _convertJsonListToObject(response.data);
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    Response response = await _dioInstance!.post(
      '/login',
      queryParameters: {
        "username": username,
        "password": password,
      },
    );
    if (response.data['error'] == null) {
      _authKey = response.data['apiKey'];
      //Updates the dioInstance to use the key retrieved
      _dioInstance!.options.queryParameters = {
        "apiKey": _authKey,
      };
    }

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> addObject(RawObject object) async {
    Response response =
        await _dioInstance!.post('/addObject', data: object.toJSON);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> register(
      String username, String password) async {
    Response response = await _dioInstance!.post(
      '/register',
      queryParameters: {
        "username": username,
        "password": password,
      },
    );
    return response.data;
  }

  @override
  Future<bool> logout(String username) async {
    Response response = await _dioInstance!.post("/logout", queryParameters: {
      'username': username,
    });
    return response.data['result'] == 'ok';
  }

  @override
  Future<Response> downloadObject(String url, String localPath) async {
    Response response = await _dioInstance!.get(
      '/object/$url',
      options: Options(responseType: ResponseType.plain),
    );
    try {
      await File(localPath).writeAsBytes(base64Decode(response.data));
    } catch (e, stacktrace) {
      debugPrint('$e');
      debugPrint('$stacktrace');
      return Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: _apiPath + '/object/$url'));
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> updateProfile(User user) async {
    Response response =
        await _dioInstance!.post("/updateProfile", queryParameters: {
      'username': user.username,
      'password': user.password,
    });

    return response.data;
  }

  @override
  Future getSingleObject(String path) async {
    Response response = await _dioInstance!
        .get(path, options: Options(responseType: ResponseType.plain));
    return response.data;
  }

  List<Object> _convertJsonListToObject(dynamic json) {
    List<Object> objects = [];
    try {
      json.forEach((element) => objects.add(Object.fromJSON(element)));
    } catch (e) {
      debugPrint('$e');
    }
    return objects;
  }
}
