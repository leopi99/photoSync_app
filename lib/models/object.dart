import 'dart:io';

import 'package:photo_sync/models/object_attributes.dart';
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
        attributes: json[ObjectAttributes.KEY_ATTRIBUTES],
        objectType: json[_KEY_TYPE],
      );

  Map<String, dynamic> get toJSON => {
        ObjectAttributes.KEY_ATTRIBUTES: attributes.toJSON,
        _KEY_TYPE: objectType.toValue,
      };
}
