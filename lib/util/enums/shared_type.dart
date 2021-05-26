enum SharedType {
  LoginUsername,
  LoginPassword,
}

extension SharedTypeExtension on SharedType {
  String get toValue => this.toString().split('.').last;
}
