import 'package:dio/dio.dart';

abstract class ObectsRepositoryInterface {

  Future<Response> getAll();
  Future<Response> getPictures(String username);
  Future<Response> getVideos(String username);
  Future<Response> addPicture(Map<String, dynamic> object);
  Future<Response> login(String username, String password);
  
}