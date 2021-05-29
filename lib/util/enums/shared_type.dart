enum SharedType {
  LoginUsername,
  LoginPassword,
  OnBoardingDone,
}

extension SharedTypeExtension on SharedType {
  String get toValue => this.toString().split('.').last;
}
