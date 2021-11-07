import 'dart:convert';

import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/models/babysitter.dart';
import 'package:flutter_client/models/babysitters_response.dart';
import 'package:flutter_client/models/error_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BabysittersController extends GetxController {
  var loading = true.obs;
  var count = 0.obs;
  var babysitters = <Babysitter>[].obs;
  var currentBabysitter = Babysitter().obs;
  final FlutterSecureStorage storage = Get.find();
  final AuthController ac = Get.find();

  void getBabysittersForChild(int id) async {
    try {
      loading(true);
      var url = Uri.parse("http://10.0.2.2:5000/Babysitters?id=$id");
      //var url = Uri.parse("http://127.0.0.1:5000/Activities?id=$id");
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
        var babysitterList =
            BabysittersResponse.fromJson(jsonDecode(response.body));
        babysitters.value = babysitterList.babysitters;
        count.value = babysitterList.count;
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      //print(e.toString());
    } finally {
      loading(false);
    }
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
        print("ok");
      } else if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      } else if (response.statusCode != 200 && response.statusCode != 401) {
        var errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
        return errorResponse;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteBabysitter(String babysitterUsername, int childId) async {
    try {
      var url = Uri.parse(
          "http://10.0.2.2:5000/Babysitters/delete?babysitterUsername=$babysitterUsername&childId=$childId");
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
        var babysitterList =
            BabysittersResponse.fromJson(jsonDecode(response.body));
        babysitters.value = babysitterList.babysitters;
        count.value = babysitterList.count;
        return babysitterList;
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
