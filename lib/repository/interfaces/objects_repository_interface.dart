import 'package:dio/dio.dart';
import 'package:photo_sync/models/raw_object.dart';
import 'package:photo_sync/models/user.dart';

abstract class ObectsRepositoryInterface {
  Future<dynamic> getAll(String userID);
  Future<dynamic> getPictures(String userID);
  Future<dynamic> getVideos(String userID);
  Future<dynamic> addPicture(RawObject object);
  Future<dynamic> login(String username, String password);
  Future<dynamic> logout(String username);
  Future<dynamic> register(String username, String password);
  Future<Response> downloadObject(String url, String localPath);
  Future<Response> updateDownloadedObject(String objectID, bool value);
  Future<dynamic> updateProfile(User user);
}
