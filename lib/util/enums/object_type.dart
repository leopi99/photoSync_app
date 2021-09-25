enum ObjectType {
  picture,
  video,
  unknown,
}

extension ObjectTypeExtension on ObjectType {
  String get toValue => toString().split('.').last;

  ///Returns the [ObjectType] from a value
  ObjectType findExact(String value) {
    late ObjectType type = ObjectType.unknown;
    for (int i = 0; i < ObjectType.values.length; i++) {
      if (ObjectType.values[i].toValue == value) {
        type = ObjectType.values[i];
        break;
      }
    }
    return type;
  }
}
