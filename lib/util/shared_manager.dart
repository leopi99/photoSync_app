import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:storage_wrapper/storage_wrapper.dart';

class SharedManager {
  late StorageWrapper _wrapper;

  static final SharedManager _instance = SharedManager._internal();

  factory SharedManager() {
    return _instance;
  }

  SharedManager._internal() {
    _wrapper = StorageWrapper.secure();
  }

  Future<String?> readValue(SharedType key) async {
    return await _wrapper.read(key: key.toValue);
  }

  Future<bool> writeValue(SharedType key, String value) async {
    return await _wrapper.write(key: key.toValue, value: value);
  }

  Future<bool> writeBool(SharedType key, bool value) async {
    return await _wrapper.write(key: key.toValue, value: '$value');
  }

  Future<bool> readBool(SharedType key) async {
    return ((await _wrapper.read(key: key.toValue) ?? 'false') == 'true');
  }
}
