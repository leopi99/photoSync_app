import 'package:dio/dio.dart';
import 'package:photo_sync/repository/interfaces/objects_repository_interface.dart';

class ObjectRepository extends ObectsRepositoryInterface {
  static const _API_PATH = "";

  late String _authKey;

  Dio? _dioInstance;

  ObjectRepository() {
    _setupDio();
  }

  _setupDio() {
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
    _authKey = response.data['key'];
    _setupDio();
    return response;
  }

  @override
  Future<Response> addPicture(Map<String, dynamic> object) {
    // TODO: implement addPicture
    throw UnimplementedError();
  }
}
