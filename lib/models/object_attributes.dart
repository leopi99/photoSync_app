class ObjectAttributes {
  static const _KEY_URL = "url";
  static const _KEY_SYNC_DATE = "sync_date";
  static const _KEY_CREATION_DATE = "creation_date";
  static const _KEY_USERNAME = "user";
  static const _KEY_PICTURE_POSITION = "position";
  static const _KEY_BYTE_SIZE = "bytes_size";
  static const _KEY_LOCAL_PATH = "local_path";
  static const _KEY_ID = "database_id";
  static const KEY_ATTRIBUTES = "attributes";

  final String url;
  final String syncDate;
  final String creationDate;
  final String username;
  final String picturePosition;
  final String localPath;
  final int pictureByteSize;
  final int databaseID;

  ObjectAttributes({
    required this.url,
    required this.syncDate,
    required this.creationDate,
    required this.username,
    required this.picturePosition,
    required this.localPath,
    required this.pictureByteSize,
    required this.databaseID,
  });

  static ObjectAttributes fromJSON(Map<String, dynamic> json) =>
      ObjectAttributes(
        creationDate: json[_KEY_CREATION_DATE],
        localPath: json[_KEY_LOCAL_PATH],
        pictureByteSize: json[_KEY_BYTE_SIZE],
        picturePosition: json[_KEY_PICTURE_POSITION],
        syncDate: json[_KEY_SYNC_DATE],
        url: json[_KEY_URL],
        username: json[_KEY_USERNAME],
        databaseID: json[_KEY_ID],
      );

  Map<String, dynamic> get toJSON => {
        _KEY_CREATION_DATE: creationDate,
        _KEY_LOCAL_PATH: localPath,
        _KEY_BYTE_SIZE: pictureByteSize,
        _KEY_PICTURE_POSITION: picturePosition,
        _KEY_SYNC_DATE: syncDate,
        _KEY_URL: url,
        _KEY_USERNAME: username,
        _KEY_ID: databaseID,
      };
}
