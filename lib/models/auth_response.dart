import 'package:flutter_client/models/auth_user.dart';

class AuthResponse {
  final AuthUser user;

  AuthResponse({required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: AuthUser.fromJson(json['user']),
    );
  }
}
