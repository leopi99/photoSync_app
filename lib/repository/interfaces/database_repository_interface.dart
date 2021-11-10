import 'package:photo_sync/models/object.dart';

abstract class DatabaseRepositoryInterface {
  /// Returns the photos as [Object] added to the database
  Future<List<Object>> getPhotos();

  ///Returns all the videos as [Object] added to the database
  Future<List<Object>> getVideos();

  ///Adds a [Object] to the database
  Future<dynamic> addObject(Object object);

  ///Returns all the [Object] from the database
  Future<List<Object>> getObjects();

  Future<void> startDatabaseRepository();

}
