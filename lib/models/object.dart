import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_sync/models/object_attributes.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/util/enums/object_type.dart';

class Object {
  static const _KEY_TYPE = "type";

  final ObjectType objectType;
  final ObjectAttributes attributes;
  final Future<File?>? futureFileBytes;
  final String _imageRemotePath;

  Object({
    required this.objectType,
    required this.attributes,
    this.futureFileBytes,
  }) : _imageRemotePath =
            '/object/${attributes.creationDate}${attributes.extension}';

  ///Returns true if the file is available offline
  Future<bool> get isDownloaded async =>
      await File(attributes.localPath).exists();

  ///Returns the object from a json
  static Object fromJSON(Map<String, dynamic> json) => Object(
        attributes:
            ObjectAttributes.fromJSON(json[ObjectAttributes.KEY_ATTRIBUTES]),
        objectType: ObjectType.Picture.findExact(json[_KEY_TYPE]),
      );

  ///Returns the json representation of the object
  Map<String, dynamic> get toJSON => {
        ObjectAttributes.KEY_ATTRIBUTES: attributes.toJSON,
        _KEY_TYPE: objectType.toValue,
      };

  Object copyWith({ObjectType? objectType, ObjectAttributes? attributes}) =>
      Object(
        objectType: objectType ?? this.objectType,
        attributes: attributes ?? this.attributes,
        futureFileBytes: this.futureFileBytes,
      );

  ///Returns the bytes of the object from cache/local memory or api
  Future<Uint8List> get getFileBytes async {
    if (futureFileBytes != null)
      return (await futureFileBytes)!.readAsBytesSync();

    Uint8List bytes;
    FileInfo? fileInfo =
        await DefaultCacheManager().getFileFromCache(attributes.creationDate);
    bytes = fileInfo?.file.readAsBytesSync() ?? Uint8List.fromList([]);
    if (bytes.isEmpty) {
      var data = (await ObjectRepository().getSingleObject(_imageRemotePath));
      bytes = base64Decode(data);
      await DefaultCacheManager().putFile(
        ObjectRepository.apiPath + _imageRemotePath,
        bytes,
        fileExtension: attributes.extension!,
        key: attributes.creationDate,
      );
    }
    return bytes;
  }
}
