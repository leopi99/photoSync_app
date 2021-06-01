class User {
  final String username;
  final String? password;
  final String? userID;

  User({
    required this.username,
    this.userID,
    this.password,
  });

  factory User.fromJSON(Map<String, dynamic> json) => User(
        username: json['username'],
        userID: json['userID'].toString(),
      );

  Map<String, dynamic> get toJSON {
    if (password == null) throw Error();
    return {
      "username": username,
      "password": password!,
    };
  }
}
