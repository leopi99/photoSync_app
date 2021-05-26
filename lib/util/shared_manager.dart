import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:storage_wrapper/storage_wrapper.dart';

class SharedManager {
  late StorageWrapper _wrapper;

  SharedManager() {
    _wrapper = StorageWrapper.secure();
  }

  Future<String?> readValue(SharedType key) async {
    return await _wrapper.read(key: key.toValue);
  }

  Future<bool> writeValue(SharedType key, String value) async {
    return await _wrapper.write(key: key.toValue, value: value);
  }
}
