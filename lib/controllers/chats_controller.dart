import 'dart:convert';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/main.dart';
import 'package:flutter_client/models/chat.dart';
import 'package:flutter_client/models/chats_response.dart';
import 'package:flutter_client/models/error_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatsController extends GetxController {
  final FlutterSecureStorage storage = Get.find();
  final AuthController ac = Get.find();
  var chats = <Chat>[].obs;
  var currentChat = Chat().obs;
  var count = 0.obs;
  var currentActivity = Chat().obs;
  var loading = true.obs;

  void getChats() async {
    loading(true);
    try {
      var url = Uri.parse("$serverUrl/Chats");
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
        var chatList = ChatsResponse.fromJson(jsonDecode(response.body));
        chats.value = chatList.chats;
        count.value = chatList.count;
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

  void addChat(String name) async {
    try {
      var url = Uri.parse("$serverUrl/Chats/add");
      var requestBody = jsonEncode(name);
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
        var chat = Chat.fromJson(jsonDecode(response.body));
        chats.add(chat);
        count.value = count.value + 1;
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void leaveChat(int chatId) async {
    try {
      var url = Uri.parse("$serverUrl/Chats/users/leave?chatId=$chatId");
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
        var chatList = ChatsResponse.fromJson(jsonDecode(response.body));
        chats.value = chatList.chats;
        count.value = chatList.count;
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }
}
