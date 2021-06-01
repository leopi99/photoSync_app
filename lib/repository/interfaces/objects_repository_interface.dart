import 'package:photo_sync/models/raw_object.dart';

abstract class ObectsRepositoryInterface {
  Future<dynamic> getAll(String userID);
  Future<dynamic> getPictures(String userID);
  Future<dynamic> getVideos(String userID);
  Future<dynamic> addPicture(RawObject object);
  Future<dynamic> login(String username, String password);
}
