class ObjectAttributes {
  static const _KEY_URL = "url";
  static const _KEY_SYNC_DATE = "sync_date";
  static const _KEY_CREATION_DATE = "creation_date";
  static const _KEY_PICTURE_POSITION = "position";
  static const _KEY_BYTE_SIZE = "bytes_size";
  static const _KEY_LOCAL_PATH = "local_path";
  static const _KEY_ID = "database_id";
  static const _KEY_IS_DOWNLOADED = "downloaded";
  static const _KEY_EXTENSION = "extension";
  static const KEY_ATTRIBUTES = "attributes";

  final String? url;
  final String? syncDate;
  final String creationDate;
  final String picturePosition;
  final String localPath;
  final bool isDownloaded;
  final int pictureByteSize;
  final int databaseID;
  final String? extension;

  DateTime get creationDateTime => DateTime.parse(creationDate);
  DateTime? get syncronizationDateTime =>
      syncDate != null ? DateTime.tryParse(syncDate!) : null;

  ObjectAttributes({
    this.url,
    this.syncDate,
    required this.creationDate,
    required this.picturePosition,
    required this.localPath,
    required this.pictureByteSize,
    required this.databaseID,
    required this.isDownloaded,
    this.extension,
  });

  static ObjectAttributes fromJSON(Map<String, dynamic> json) =>
      ObjectAttributes(
        isDownloaded: json[_KEY_IS_DOWNLOADED],
        creationDate: json[_KEY_CREATION_DATE],
        localPath: json[_KEY_LOCAL_PATH],
        pictureByteSize: json[_KEY_BYTE_SIZE],
        picturePosition: json[_KEY_PICTURE_POSITION],
        syncDate: json[_KEY_SYNC_DATE],
        url: json[_KEY_URL],
        databaseID: json[_KEY_ID],
        extension: json[_KEY_EXTENSION],
      );

  Map<String, dynamic> get toJSON => {
        _KEY_CREATION_DATE: creationDate,
        _KEY_LOCAL_PATH: localPath,
        _KEY_BYTE_SIZE: pictureByteSize,
        _KEY_PICTURE_POSITION: picturePosition,
        _KEY_SYNC_DATE: syncDate ?? '',
        _KEY_URL: url ?? '',
        _KEY_ID: databaseID,
        _KEY_IS_DOWNLOADED: isDownloaded,
        _KEY_EXTENSION: extension ?? '',
      };

  ObjectAttributes copyWith({
    String? url,
    String? syncDate,
    String? creationDate,
    String? picturePosition,
    String? localPath,
    bool? isDownloaded,
    int? pictureByteSize,
  }) =>
      ObjectAttributes(
        creationDate: creationDate ?? this.creationDate,
        databaseID: this.databaseID,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        localPath: localPath ?? this.localPath,
        pictureByteSize: pictureByteSize ?? this.pictureByteSize,
        picturePosition: picturePosition ?? this.picturePosition,
        syncDate: syncDate ?? this.syncDate,
        url: url ?? this.url,
      );
}
