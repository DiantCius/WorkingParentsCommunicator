import 'dart:convert';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/main.dart';
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
  var newActivities = <Activity>[].obs;
  var count = 0.obs;
  var currentActivity = Activity().obs;
  var date = ''.obs;
  final FlutterSecureStorage storage = Get.find();
  final AuthController ac = Get.find();

  void incrementTest() {
    test++;
  }

  void getActivities(int id) async {
    try {
      loading(true);
      var url = Uri.parse("$serverUrl/Activities?id=$id");
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
    } finally {
      getActivitiesFromToday();
      loading(false);
    }
  }

  List<Activity> returnActivities() {
    return activities.value;
  }

  void addActivity(String action, String notes, int id) async {
    try {
      loading(true);
      var url = Uri.parse("$serverUrl/Activities/add");
      var requestBody =
          jsonEncode({'action': action, 'notes': notes, 'childId': id});
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
        getActivitiesByDate();
        print(activities.length);
        print(newActivities.length);
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

  void deleteActivity(int activityId, int childId) async {
    try {
      var url = Uri.parse(
          "$serverUrl/Activities/delete?activityId=$activityId&childId=$childId");
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
    } finally {
      getActivitiesByDate();
    }
  }

  Future editActivity2(
      int activityId, int childId, String action, String notes) async {
    try {
      var url = Uri.parse("$serverUrl/Activities/edit");
      var requestBody = jsonEncode({
        'activityId': activityId,
        'childId': childId,
        'action': action,
        'notes': notes
      });
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
      getActivitiesByDate();
    }
  }

  void getActivitiesByDate() {
    newActivities.value = returnActivities()
        .where((element) =>
            element.postTime!.substring(0, 10).replaceAll('T', ' ') ==
            date.value)
        .toList();
  }

  void getActivitiesFromToday() {
    newActivities.value = returnActivities()
        .where((element) =>
            element.postTime!.substring(0, 10).replaceAll('T', ' ') ==
            DateTime.now().toString().substring(0, 10))
        .toList();
  }
}
