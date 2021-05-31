class User {
  final String username;

  User({
    required this.username,
  });

  factory User.fromJSON(Map<String, dynamic> json) => User(
        username: json['username'],
      );
}
