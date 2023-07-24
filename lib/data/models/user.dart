class User {
  final String username;
  final String role;
  final String token;

  User({
    required this.username,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'role': role,
        'token': token,
      };
 
}