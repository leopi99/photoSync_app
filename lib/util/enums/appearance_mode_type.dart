enum AppearanceModeType {
  Dark_Mode,
  Light_Mode,
  FollowS_ystem,
}

extension AppearanceModeTypeExtension on AppearanceModeType {
  /// from "AppearanceModeType.Dark_Mode" to "Dark_Mode"
  String get toValue => this.toString().split('.').last;

  ///From "AppearanceModeType.Dark_Mode" to "Dark Mode"
  String get toValueWithSeparation => this.toValue.replaceAll('_', ' ');
}
