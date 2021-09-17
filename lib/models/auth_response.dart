import 'package:flutter_client/models/user.dart';

class AuthResponse {
  final User user;

  AuthResponse({required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
    );
  }
}
