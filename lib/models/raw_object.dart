import 'dart:typed_data' show Int8List;
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/models/object.dart';

class RawObject {
  final Object object;
  final Int8List bytes;

  RawObject({
    required this.object,
    required this.bytes,
  });

  Map<String, dynamic> get toJSON => {
        'object': object.toJSON,
        'fileBytes': bytes.buffer.asUint8List().toList(),
        'userID': AuthBlocInherited.of(navigatorKey.currentContext!)
            .currentUser!
            .userID,
      };
}
