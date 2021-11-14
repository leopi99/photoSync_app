import 'package:geocoding/geocoding.dart';
import 'package:json_annotation/json_annotation.dart';

part 'object_attributes.g.dart';

@JsonSerializable()
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

  @JsonKey(name: _keySyncDate)
  final String? syncDate;
  @JsonKey(name: _keyCreationDate)
  final String creationDate;

  @JsonKey(name: _keyPicturePosition)
  final String picturePosition;

  @JsonKey(name: _keyLocalPath)
  final String localPath;

  @JsonKey(name: _keyByteSize)
  final int pictureByteSize;

  @JsonKey(name: _keyId)
  final int databaseID;

  @JsonKey(name: _keyExtension)
  final String? extension;

  @JsonKey(name: _keyLocalId)
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
    this.pictureByteSize = 0,
    this.databaseID = 0,
    required this.localID,
    required this.extension,
  });

  factory ObjectAttributes.fromJson(Map<String, dynamic> json) =>
      _$ObjectAttributesFromJson(json);

  Map<String, dynamic> get toJson => _$ObjectAttributesToJson(this);

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
