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

  Object({
    required this.objectType,
    required this.attributes,
    this.futureFileBytes,
  });

  ///Returns true if the file is available offline
  Future<bool> get isDownloaded async =>
      await File(attributes.localPath).exists();

  static Object fromJSON(Map<String, dynamic> json) => Object(
        attributes:
            ObjectAttributes.fromJSON(json[ObjectAttributes.KEY_ATTRIBUTES]),
        objectType: ObjectType.Picture.findExact(json[_KEY_TYPE]),
      );

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

  Future<Uint8List> get getFileBytes async {
    if (futureFileBytes != null) {
      return (await futureFileBytes)!.readAsBytesSync();
    }
    Uint8List bytes;
    FileInfo? fileInfo =
        await DefaultCacheManager().getFileFromCache(attributes.creationDate);

    bytes = fileInfo?.file.readAsBytesSync() ?? Uint8List.fromList([]);
    if (bytes.isEmpty) {
      var data = (await ObjectRepository().getSingleObject(
          '/object/${attributes.creationDate}${attributes.extension}'));
      bytes = base64Decode(data);
      await DefaultCacheManager().putFile(
        ObjectRepository.apiPath +
            '/object/${attributes.creationDate}${attributes.extension}',
        bytes,
        fileExtension: attributes.extension!,
        key: attributes.creationDate,
      );
    }
    return bytes;
  }
}
