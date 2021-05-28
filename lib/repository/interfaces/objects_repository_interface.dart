import 'package:photo_sync/models/raw_object.dart';

abstract class ObectsRepositoryInterface {
  Future<dynamic> getAll();
  Future<dynamic> getPictures(String username);
  Future<dynamic> getVideos(String username);
  Future<dynamic> addPicture(RawObject object);
  Future<dynamic> login(String username, String password);
}
