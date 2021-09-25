enum SharedType {
  loginUsername,
  loginPassword,
  onBoardingDone,
  appAppearance,
  backgroundBackup,
}

extension SharedTypeExtension on SharedType {
  String get toValue => toString().split('.').last;
}
