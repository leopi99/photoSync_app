import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:photo_sync/models/raw_object.dart';
import 'package:photo_sync/models/user.dart';
import 'package:photo_sync/repository/interfaces/objects_repository_interface.dart';
import 'package:photo_sync/util/api_connection_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ObjectRepository extends ObectsRepositoryInterface {
  static const _HOST =
      "http://10.0.2.2"; //This address works in the android emulator => change to the ip address where you host the api
  static const _PORT = ":8010"; //Port dedicated to the api
  static const _API_PATH = "$_HOST$_PORT/photoSync/api/v1";
  static get apiPath => _API_PATH;

  String? _authKey;

  Dio? _dioInstance;

  static final ObjectRepository _singleton = ObjectRepository._internal();

  factory ObjectRepository() {
    return _singleton;
  }

  ObjectRepository._internal();

  ///Creates the dio instance, if already present, sets the headers
  void setupDio() {
    print('ApiPath: $_API_PATH');
    if (_dioInstance == null) {
      BaseOptions _dioOptions = BaseOptions(
        baseUrl: _API_PATH,
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
  Future<dynamic> getAll(String userID) async {
    Response response = await _dioInstance!.get(
      '/getAll',
      queryParameters: {"userID": userID},
    );
    return response.data;
  }

  @override
  Future<dynamic> getPictures(String userID) async {
    Response response = await _dioInstance!.get(
      '/getPictures',
      queryParameters: {"userID": userID},
    );
    return response.data;
  }

  @override
  Future<dynamic> getVideos(String userID) async {
    Response response = await _dioInstance!.get(
      '/getVideos',
      queryParameters: {"userID": userID},
    );
    return response.data;
  }

  @override
  Future<dynamic> login(String username, String password) async {
    Response response = await _dioInstance!.post(
      '/login',
      queryParameters: {
        "username": username,
        "password": password,
      },
    );
    if (response.data['error'] == null && response.data['apiKey'] != null) {
      _authKey = response.data['apiKey'];
      //Updates the dioInstance to use the key retrieved
      _dioInstance!.options.headers = {
        "apiKey": _authKey,
      };
      _dioInstance!.options.queryParameters = {
        "apiKey": _authKey,
      };
    }

    return response.data;
  }

  @override
  Future<dynamic> addObject(RawObject object, int userID) async {
    Response response = await _dioInstance!.post('/addObject',
        data: object.toJSON, queryParameters: {'userID': userID});
    return response.data;
  }

  @override
  Future register(String username, String password) async {
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
  Future logout(String username) async {
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
      print(e);
      print(stacktrace);
      return Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: _API_PATH + '/object/$url'));
    }
    return response;
  }

  @override
  Future<dynamic> updateProfile(User user) async {
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
}
