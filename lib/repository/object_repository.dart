import 'package:dio/dio.dart';
import 'package:photo_sync/models/raw_object.dart';
import 'package:photo_sync/repository/interfaces/objects_repository_interface.dart';

class ObjectRepository extends ObectsRepositoryInterface {
  static const _HOST = "192.168.1.7";
  static const _PORT = ":8080";
  static const _API_PATH = "$_HOST$_PORT/photoSync/api/v1";

  late String _authKey;

  Dio? _dioInstance;

  static final ObjectRepository _singleton = ObjectRepository._internal();

  factory ObjectRepository() {
    return _singleton;
  }

  ObjectRepository._internal();

  void setupDio() {
    if (_dioInstance == null) {
      BaseOptions _dioOptions = BaseOptions(
        responseType: ResponseType.json,
        baseUrl: _API_PATH,
      );
      _dioInstance = Dio(_dioOptions);
      return;
    }
    _dioInstance!.options.headers = {
      'apiKey': _authKey,
    };
  }

  @override
  Future<Response> getAll() async {
    Response response = await _dioInstance!.get('/getAll');
    return response;
  }

  @override
  Future<Response> getPictures(String username) async {
    Response response = await _dioInstance!.get('/getPictures');
    return response;
  }

  @override
  Future<Response> getVideos(String username) async {
    Response response = await _dioInstance!.get('/getVideos');
    return response;
  }

  @override
  Future<Response> login(String username, String password) async {
    Response response = await _dioInstance!.post(
      '/login',
      queryParameters: {
        "username": username,
        "password": password,
      },
    );
    if (response.data['error'] == null) {
      _authKey = response.data['key'];
      //Updates the dioInstance to use the key retrieved
      setupDio();
    }
    return response;
  }

  @override
  Future<Response> addPicture(RawObject object) async {
    Response response = await _dioInstance!
        .post('/addPicture', queryParameters: {'data': object.toJSON});
    return response;
  }
}
