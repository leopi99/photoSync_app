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

  Future<String?> readString(SharedType key) async {
    return await _wrapper.read(key: key.toValue);
  }

  Future<bool> writeString(SharedType key, String value) async {
    return await _wrapper.write(key: key.toValue, value: value);
  }

  Future<bool> writeBool(SharedType key, bool value) async {
    return await _wrapper.write(key: key.toValue, value: '$value');
  }

  Future<bool> readBool(SharedType key) async {
    return ((await _wrapper.read(key: key.toValue) ?? 'false') == 'true');
  }

  Future<void> logout() async {
    await _wrapper.delete(key: SharedType.AppAppearance.toValue);
    await _wrapper.delete(key: SharedType.LoginPassword.toValue);
    await _wrapper.delete(key: SharedType.LoginUsername.toValue);
  }
}
