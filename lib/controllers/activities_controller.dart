import 'dart:convert';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/models/activities_response.dart';
import 'package:flutter_client/models/activity.dart';
import 'package:flutter_client/models/error_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ActivitiesController extends GetxController {
  var test = 0.obs;
  var loading = true.obs;
  var isEdited = true.obs;
  var activities = <Activity>[].obs;
  var count = 0.obs;
  var currentActivity = Activity().obs;
  final FlutterSecureStorage storage = Get.find();
  final AuthController ac = Get.find();

  void incrementTest() {
    test++;
  }

  //dupa

  void getActivities(int id) async {
    try {
      loading(true);
      var url = Uri.parse("http://10.0.2.2:5000/Activities?id=$id");
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
        var activityList = ActivityResponse.fromJson(jsonDecode(response.body));
        activities.value = activityList.activities;
        count.value = activityList.count;
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

  void addActivity(String action, int id) async {
    try {
      var url = Uri.parse("http://10.0.2.2:5000/Activities/add");
      //var url = Uri.parse("http://127.0.0.1:5000/Activities/add");
      var requestBody = jsonEncode({'action': action, 'childId': id});
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
        var activityList = ActivityResponse.fromJson(jsonDecode(response.body));
        activities.value = activityList.activities;
        count.value = activityList.count;
        //print("dobzie");
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteActivity(int activityId, int childId) async {
    try {
      var url = Uri.parse(
          "http://10.0.2.2:5000/Activities/delete?activityId=$activityId&childId=$childId");
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
        var activityList = ActivityResponse.fromJson(jsonDecode(response.body));
        activities.value = activityList.activities;
        count.value = activityList.count;
        print("dobzie");
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void editActivity(int activityId, int childId, String action) async {
    try {
      var url = Uri.parse("http://10.0.2.2:5000/Activities/edit");
      //var url = Uri.parse("http://127.0.0.1:5000/Activities/add");
      var requestBody = jsonEncode(
          {'activityId': activityId, 'childId': childId, 'action': action});
      String token = '';
      await storage
          .read(key: 'jwt')
          .then((value) => {if (value != null) token = value});

      final response = await http.put(url, body: requestBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        /*var activityList = ActivityResponse.fromJson(jsonDecode(response.body));
        activities.value = activityList.activities;
        count.value = activityList.count;*/
        print(isEdited.value);
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  Future editActivity2(int activityId, int childId, String action) async {
    try {
      var url = Uri.parse("http://10.0.2.2:5000/Activities/edit");
      //var url = Uri.parse("http://127.0.0.1:5000/Activities/add");
      var requestBody = jsonEncode(
          {'activityId': activityId, 'childId': childId, 'action': action});
      String token = '';
      await storage
          .read(key: 'jwt')
          .then((value) => {if (value != null) token = value});

      final response = await http.put(url, body: requestBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        var activityList = ActivityResponse.fromJson(jsonDecode(response.body));
        activities.value = activityList.activities;
        count.value = activityList.count;
        //var activityResponse = ActivityResponse.fromJson(jsonDecode(response.body));
        return activityList;
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
    } finally {
    }
  }
}
