import 'dart:convert';

import 'package:flutter_client/models/auth_response.dart';
import 'package:flutter_client/models/error_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;
  var token = "".obs;
  final FlutterSecureStorage storage = Get.put(FlutterSecureStorage());
  //final FlutterSecureStorage storage = Get.find();

  void logOut() async {
    await storage.delete(key: 'jwt');
    isLoggedIn(false);
    //token('');
  }

  Future logIn(String email, String password) async {
    var url = Uri.parse("http://10.0.2.2:5000/Users/login");
    //var url = Uri.parse("http://192.168.100.8:5000/Users/login");
    var requestBody = jsonEncode({'email': email, 'password': password});
    try {
      final response = await http.post(url, body: requestBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
      if (response.statusCode == 200) {
        var authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        storage.write(key: 'jwt', value: authResponse.user.token);
        isLoggedIn(true);
        return authResponse;
      }
      if (response.statusCode == 401) {
        logOut();
        Get.toNamed("/login");
      } else {
        isLoggedIn(false);
        var errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
        return errorResponse;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUp(String username, String email, String password) async {
    var url = Uri.parse("http://10.0.2.2:5000/Users/register");
    //var url = Uri.parse("http://192.168.100.8:5000/Users/register");
    var requestBody = jsonEncode(
        {'username': username, 'email': email, 'password': password});
    try {
      final response = await http.post(url, body: requestBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
      if (response.statusCode == 200) {
        var authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        storage.write(key: 'jwt', value: authResponse.user.token);
        isLoggedIn(true);
        return authResponse;
      } else {
        isLoggedIn(false);
        var errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
        return errorResponse;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future forgotPassword(String email) async {
    var url = Uri.parse("http://10.0.2.2:5000/Users/password");
    var requestBody = jsonEncode({
      'email': email,
    });
    try {
      final response = await http.post(url, body: requestBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
      if (response.statusCode == 200) {
        //var authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        return "ok";
      } else {
        isLoggedIn(false);
        var errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
        return errorResponse;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
