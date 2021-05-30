enum SharedType {
  LoginUsername,
  LoginPassword,
  OnBoardingDone,
  AppAppearance,
}

extension SharedTypeExtension on SharedType {
  String get toValue => this.toString().split('.').last;
}
