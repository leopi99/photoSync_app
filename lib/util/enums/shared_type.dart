enum SharedType {
  LoginUsername,
  LoginPassword,
  OnBoardingDone,
  AppAppearance,
  BackgroundBackup,
}

extension SharedTypeExtension on SharedType {
  String get toValue => this.toString().split('.').last;
}
