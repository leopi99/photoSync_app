class User {
  final String username;
  final String email;

  User({
    required this.username,
    required this.email,
  });

  factory User.fromJSON(Map<String, dynamic> json) => User(
        email: json['email'],
        username: json['username'],
      );
}
