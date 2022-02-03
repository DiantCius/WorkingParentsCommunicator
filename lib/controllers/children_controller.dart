import 'dart:convert';

import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/main.dart';
import 'package:flutter_client/models/child.dart';
import 'package:flutter_client/models/children_response.dart';
import 'package:flutter_client/models/error_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChildrenController extends GetxController {
  var loading = true.obs;
  var children = <Child>[].obs;
  var count = 0.obs;
  var currentChild = Child().obs;
  final FlutterSecureStorage storage = Get.find();

  final AuthController ac = Get.find();

  /*@override
  void onInit() {
    getChildren();
    super.onInit();
  }*/

  /*Future getChildren() async {
    var url = Uri.parse("http://10.0.2.2:5000/Children");
    String token = '';
    storage
        .read(key: "jwt")
        .then((value) => {if (value != null) token = value});
    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      var childrenList = ChildrenResponse.fromJson(jsonDecode(response.body));
      children.value = childrenList.children;
      return ChildrenResponse.fromJson(jsonDecode(response.body));
    } else {
      return ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }*/

  void getChildren() async {
    try {
      loading(true);
      var url = Uri.parse("$serverUrl/Children");
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
        var childrenList = ChildrenResponse.fromJson(jsonDecode(response.body));
        children.value = childrenList.children;
        count.value = childrenList.count;
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
    }
  }

  void addChild(String name, String birthDate) async {
    try {
      var url = Uri.parse("$serverUrl/Children/add");
      var requestBody = jsonEncode({'name': name, 'birthDate': birthDate});
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
        var childrenList = ChildrenResponse.fromJson(jsonDecode(response.body));
        children.value = childrenList.children;
        count.value = childrenList.count;
        print('ok');
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  Future deleteChild(int childId) async {
    try {
      var url = Uri.parse("$serverUrl/Children/delete?childId=$childId");
      String token = '';
      await storage
          .read(key: 'jwt')
          .then((value) => {if (value != null) token = value});

      final response = await http.delete(url, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        var childrenList = ChildrenResponse.fromJson(jsonDecode(response.body));
        children.value = childrenList.children;
        count.value = childrenList.count;
        return childrenList;
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      } else {
        var errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
        return errorResponse;
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }
}
