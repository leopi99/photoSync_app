import 'package:geocoding/geocoding.dart';

class ObjectAttributes {
  static const _keySyncDate = "sync_date";
  static const _keyCreationDate = "creation_date";
  static const _keyPicturePosition = "position";
  static const _keyByteSize = "bytes_size";
  static const _keyLocalPath = "local_path";
  static const _keyId = "database_id";
  static const _keyExtension = "extension";
  static const _keyLocalId = "local_id";
  static const keyAttributes = "attributes";

  final String? syncDate;
  final String creationDate;
  final String picturePosition;
  final String localPath;
  final int pictureByteSize;
  final int databaseID;
  final String? extension;
  final int localID;

  DateTime get creationDateTime =>
      DateTime.tryParse(creationDate) ??
      DateTime.fromMillisecondsSinceEpoch(int.parse(creationDate));

  DateTime? get syncronizationDateTime {
    if (syncDate == null) return null;
    if (DateTime.tryParse(syncDate!) == null) {
      if (int.tryParse(syncDate!) == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(int.parse(syncDate!));
    }
  }

  Future<String?> get positionFromCoordinates async {
    List<Placemark> address = await placemarkFromCoordinates(
        double.parse(picturePosition.split(',').first.trim()),
        double.parse(picturePosition.split(',').last.trim()));
    return address.first.locality;
  }

  ObjectAttributes({
    this.syncDate,
    required this.creationDate,
    required this.picturePosition,
    required this.localPath,
    required this.pictureByteSize,
    required this.databaseID,
    required this.localID,
    required this.extension,
  });

  static ObjectAttributes fromJSON(Map<String, dynamic> json) =>
      ObjectAttributes(
        creationDate: json[_keyCreationDate],
        localPath: json[_keyLocalPath],
        pictureByteSize: json[_keyByteSize],
        picturePosition: json[_keyPicturePosition],
        syncDate: json[_keySyncDate],
        databaseID: json[_keyId],
        extension: json[_keyExtension],
        localID: json[_keyLocalId],
      );

  Map<String, dynamic> get toJSON => {
        _keyCreationDate: creationDate,
        _keyLocalPath: localPath,
        _keyByteSize: pictureByteSize,
        _keyPicturePosition: picturePosition,
        _keySyncDate: syncDate ?? '',
        _keyId: databaseID,
        _keyExtension: extension ?? '',
        _keyLocalId: localID,
      };

  ObjectAttributes copyWith({
    String? syncDate,
    String? creationDate,
    String? picturePosition,
    String? localPath,
    int? pictureByteSize,
    String? extension,
    int? localID,
  }) =>
      ObjectAttributes(
        creationDate: creationDate ?? this.creationDate,
        databaseID: databaseID,
        localPath: localPath ?? this.localPath,
        pictureByteSize: pictureByteSize ?? this.pictureByteSize,
        picturePosition: picturePosition ?? this.picturePosition,
        syncDate: syncDate ?? this.syncDate,
        extension: extension ?? this.extension,
        localID: localID ?? this.localID,
      );
}
