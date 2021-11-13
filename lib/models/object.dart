import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:photo_sync/models/object_attributes.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/util/enums/object_type.dart';

part 'object.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class Object {
  static const _keyType = "type";

  @JsonKey(name: _keyType, unknownEnumValue: ObjectType.unknown)
  final ObjectType objectType;
  @JsonKey(name: 'attributes')
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
  factory Object.fromJson(Map<String, dynamic> json) => _$ObjectFromJson(json);

  ///Returns the json representation of the object
  Map<String, dynamic> toJson() => _$ObjectToJson(this);

  Object copyWith({ObjectType? objectType, ObjectAttributes? attributes}) =>
      Object(
        objectType: objectType ?? this.objectType,
        attributes: attributes ?? this.attributes,
        futureFileBytes: futureFileBytes,
      );

  ///Returns the bytes of the object from cache/local memory or api
  Future<Uint8List> get getFileBytes async {
    if (futureFileBytes != null) {
      return (await futureFileBytes)!.readAsBytesSync();
    }

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
