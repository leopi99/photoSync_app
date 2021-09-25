enum AppearanceModeType {
  darkMode,
  lightMode,
  followSystem,
}

extension AppearanceModeTypeExtension on AppearanceModeType {
  /// from "AppearanceModeType.Dark_Mode" to "Dark_Mode"
  String get toValue => toString().split('.').last;

  ///From "AppearanceModeType.Dark_Mode" to "Dark Mode"
  String get toValueWithSeparation => toValue.replaceAll('_', ' ');

  ///Returns true if the accessed type is equal to the one passed as parameter
  bool equals(AppearanceModeType type) => type == this;
}
