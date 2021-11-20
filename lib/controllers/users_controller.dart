import 'dart:convert';

import 'package:flutter_client/models/error_response.dart';
import 'package:flutter_client/models/user.dart';
import 'package:flutter_client/models/users_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_controller.dart';

class UsersController extends GetxController {
  var loading = true.obs;
  var count = 0.obs;
  var users = <User>[].obs;
  var currentUser = User().obs;
  var newUserList = <User>[].obs;
  final FlutterSecureStorage storage = Get.find();
  final AuthController ac = Get.find();

  void getUsers(int id) async {
    try {
      loading(true);
      var url = Uri.parse("http://10.0.2.2:5000/Users?id=$id");
      String token = '';
      await storage
          .read(key: 'jwt')
          .then((value) => {if (value != null) token = value});

      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        var userList = UsersResponse.fromJson(jsonDecode(response.body));
        users.value = userList.users;
        count.value = userList.count;
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
      print(count.value);
      newUserList.value = users.value;
    }
  }

  List<User> returnUsers() {
    return users.value;
  }

  Future addBabysitterToChild(int childId, String personEmail) async {
    try {
      var url = Uri.parse("http://10.0.2.2:5000/Babysitters/Add");
      //var url = Uri.parse("http://127.0.0.1:5000/Activities/add");
      var requestBody =
          jsonEncode({'childId': childId, 'personEmail': personEmail});
      String token = '';
      await storage
          .read(key: 'jwt')
          .then((value) => {if (value != null) token = value});

      final response = await http.post(url, body: requestBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        var userList = UsersResponse.fromJson(jsonDecode(response.body));
        users.value = userList.users;
        count.value = userList.count;
        return userList;
      } else if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      } else  {
        var errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
        return errorResponse;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      newUserList.value = users.value;
    }
  }
}
