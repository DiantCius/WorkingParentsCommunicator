import 'dart:convert';

import 'package:flutter_client/models/auth_response.dart';
import 'package:flutter_client/models/error_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future attemptLogIn(String email, String password) async {
    var url = Uri.parse("http://10.0.2.2:5000/Users/login");
    //var url = Uri.parse("http://192.168.100.8:5000/Users/login");
    var requestBody = jsonEncode({'email': email, 'password': password});
    try {
      final response = await http.post(url, body: requestBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else
        return ErrorResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      print(e.toString());
    }
  }

  static Future attemptSignUp(String username, String email, String password) async {
    var url = Uri.parse("http://10.0.2.2:5000/Users/register");
    //var url = Uri.parse("http://192.168.100.8:5000/Users/register");
    var requestBody = jsonEncode({'username': username,'email': email, 'password': password});
    try {
      final response = await http.post(url, body: requestBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else
        return ErrorResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      print(e.toString());
    }
  }
}
