import 'package:dio/dio.dart';
import 'package:photo_sync/models/raw_object.dart';

abstract class ObectsRepositoryInterface {

  Future<Response> getAll();
  Future<Response> getPictures(String username);
  Future<Response> getVideos(String username);
  Future<Response> addPicture(RawObject object);
  Future<Response> login(String username, String password);
  
}