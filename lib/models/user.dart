class User {
  final String username;
  final String? password;

  User({
    required this.username,
    this.password,
  });

  factory User.fromJSON(Map<String, dynamic> json) => User(
        username: json['username'],
      );

  Map<String, dynamic> get toJSON {
    if (password == null) throw Error();
    return {
      "username": username,
      "password": password!,
    };
  }
}
