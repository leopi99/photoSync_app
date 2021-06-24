import 'package:dio/dio.dart';
import 'package:photo_sync/models/raw_object.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/models/user.dart';

///Abstract class for the [ObjectsRepository]
abstract class ObjectsRepositoryInterface {
  ///Returns a list of [Object] as in models
  Future<List<Object>> getAll(Function errorCallBack);

  ///Returns a list of [Object] as in models
  Future<List<Object>> getPictures(Function errorCallBack);

  ///Returns a list of [Object] as in models
  Future<List<Object>> getVideos(Function errorCallBack);

  ///Uploads a [RawObject]
  Future<Map<String, dynamic>> addObject(RawObject object, int userID);

  ///Logs into the api
  Future<Map<String, dynamic>> login(String username, String password);

  ///Logs out
  Future<bool> logout(String username);

  ///Creates a user
  Future<Map<String, dynamic>> register(String username, String password);

  ///Downloads a [Object] and saves it in localPath, must contain the extension
  Future<Response> downloadObject(String url, String localPath);

  ///Updates the profile
  Future<Map<String, dynamic>> updateProfile(User user);

  ///Returns the base64 encoded object
  Future<dynamic> getSingleObject(String fileName);
}
