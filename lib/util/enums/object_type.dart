enum ObjectType {
  Picture,
  Video,
  Unknown,
}

extension ObjectTypeExtension on ObjectType {
  String get toValue => this.toString().split('.').last;

  ///Returns the [ObjectType] from a value
  ObjectType findExact(String value) {
    late ObjectType type = ObjectType.Unknown;
    for (int i = 0; i < ObjectType.values.length; i++) {
      if (ObjectType.values[i].toValue == value) {
        type = ObjectType.values[i];
        break;
      }
    }
    return type;
  }
}
