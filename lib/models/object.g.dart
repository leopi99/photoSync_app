// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Object _$ObjectFromJson(Map<String, dynamic> json) => Object(
      objectType: $enumDecode(_$ObjectTypeEnumMap, json['type'],
          unknownValue: ObjectType.unknown),
      attributes:
          ObjectAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ObjectToJson(Object instance) => <String, dynamic>{
      'type': _$ObjectTypeEnumMap[instance.objectType],
      'attributes': instance.attributes,
    };

const _$ObjectTypeEnumMap = {
  ObjectType.picture: 'picture',
  ObjectType.video: 'video',
  ObjectType.unknown: 'unknown',
};
