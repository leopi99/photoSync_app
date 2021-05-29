enum SharedType {
  LoginUsername,
  LoginPassword,
  LoginDone,
  OnBoardingDone,
}

extension SharedTypeExtension on SharedType {
  String get toValue => this.toString().split('.').last;
}
