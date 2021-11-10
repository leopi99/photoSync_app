// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectAttributes _$ObjectAttributesFromJson(Map<String, dynamic> json) =>
    ObjectAttributes(
      syncDate: json['sync_date'] as String?,
      creationDate: json['creation_date'] as String,
      picturePosition: json['position'] as String,
      localPath: json['local_path'] as String,
      pictureByteSize: json['bytes_size'] as int,
      databaseID: json['database_id'] as int,
      localID: json['local_id'] as int,
      extension: json['extension'] as String?,
    );

Map<String, dynamic> _$ObjectAttributesToJson(ObjectAttributes instance) =>
    <String, dynamic>{
      'sync_date': instance.syncDate,
      'creation_date': instance.creationDate,
      'position': instance.picturePosition,
      'local_path': instance.localPath,
      'bytes_size': instance.pictureByteSize,
      'database_id': instance.databaseID,
      'extension': instance.extension,
      'local_id': instance.localID,
    };
