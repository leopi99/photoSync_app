import 'package:dio/dio.dart';
import 'package:photo_sync/models/raw_object.dart';
import 'package:photo_sync/repository/interfaces/objects_repository_interface.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ObjectRepository extends ObectsRepositoryInterface {
  static const _HOST = "http://10.0.2.2";
  static const _PORT = ":8010";
  static const _API_PATH = "$_HOST$_PORT/photoSync/api/v1";

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
        connectTimeout: 21600,
        validateStatus: (_) => true,
      );
      _dioInstance = Dio(_dioOptions);
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
      return;
    }
  }

  Map<String, String>? get getHeaders => _dioInstance?.options.headers
      .map((key, value) => MapEntry(key, value.toString()));

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
  Future<dynamic> addPicture(RawObject object) async {
    Response response = await _dioInstance!
        .post('/addPicture', queryParameters: {'data': object.toJSON});
    return response.data;
  }
}
