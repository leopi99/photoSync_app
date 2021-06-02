enum AppearanceModeType {
  Dark_Mode,
  Light_Mode,
  Follow_System,
}

extension AppearanceModeTypeExtension on AppearanceModeType {
  /// from "AppearanceModeType.Dark_Mode" to "Dark_Mode"
  String get toValue => this.toString().split('.').last;

  ///From "AppearanceModeType.Dark_Mode" to "Dark Mode"
  String get toValueWithSeparation => this.toValue.replaceAll('_', ' ');

  ///Returns true if the accessed type is equal to the one passed as parameter
  bool equals (AppearanceModeType type) => type == this;
}
