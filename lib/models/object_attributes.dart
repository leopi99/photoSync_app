import 'package:flutter_geocoder/geocoder.dart';

class ObjectAttributes {
  static const _KEY_SYNC_DATE = "sync_date";
  static const _KEY_CREATION_DATE = "creation_date";
  static const _KEY_PICTURE_POSITION = "position";
  static const _KEY_BYTE_SIZE = "bytes_size";
  static const _KEY_LOCAL_PATH = "local_path";
  static const _KEY_ID = "database_id";
  static const _KEY_EXTENSION = "extension";
  static const _KEY_LOCAL_ID = "local_id";
  static const KEY_ATTRIBUTES = "attributes";

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
    Coordinates coordinates = Coordinates(
        double.parse(picturePosition.split(',').first.trim()),
        double.parse(picturePosition.split(',').last.trim()));
    List<Address> address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
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
        creationDate: json[_KEY_CREATION_DATE],
        localPath: json[_KEY_LOCAL_PATH],
        pictureByteSize: json[_KEY_BYTE_SIZE],
        picturePosition: json[_KEY_PICTURE_POSITION],
        syncDate: json[_KEY_SYNC_DATE],
        databaseID: json[_KEY_ID],
        extension: json[_KEY_EXTENSION],
        localID: json[_KEY_LOCAL_ID],
      );

  Map<String, dynamic> get toJSON => {
        _KEY_CREATION_DATE: creationDate,
        _KEY_LOCAL_PATH: localPath,
        _KEY_BYTE_SIZE: pictureByteSize,
        _KEY_PICTURE_POSITION: picturePosition,
        _KEY_SYNC_DATE: syncDate ?? '',
        _KEY_ID: databaseID,
        _KEY_EXTENSION: extension ?? '',
        _KEY_LOCAL_ID: localID,
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
        databaseID: this.databaseID,
        localPath: localPath ?? this.localPath,
        pictureByteSize: pictureByteSize ?? this.pictureByteSize,
        picturePosition: picturePosition ?? this.picturePosition,
        syncDate: syncDate ?? this.syncDate,
        extension: extension ?? this.extension,
        localID: localID ?? this.localID,
      );
}
