class AuthUser {
  final String username;
  final String email;
  final String token;

  AuthUser({
    required this.username,
    required this.email,
    required this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      username: json['username'],
      email: json['email'],
      token: json['token'],
    );
  }
}