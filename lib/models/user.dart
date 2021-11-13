import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'password')
  final String? password;
  @JsonKey(name: 'userID', includeIfNull: false, toJson: _toNull)
  final int? userID;

  User({
    required this.username,
    this.userID,
    this.password,
  });

  factory User.fromJSON(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({String? username, String? password, int? userID}) => User(
        username: username ?? this.username,
        password: password ?? this.password,
        userID: userID ?? this.userID,
      );

  static _toNull(_) => null;
}
