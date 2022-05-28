import 'dart:convert';

import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/main.dart';
import 'package:flutter_client/models/chat_user.dart';
import 'package:flutter_client/models/chat_users_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatUsersController extends GetxController {
  var loading = true.obs;
  var users = <ChatUser>[].obs;
  var currentListUser = ChatUser().obs;
  var currentUser = ChatUser().obs;
  var newUserList = <ChatUser>[].obs;
  var count = 0.obs;
  var chatUserList = <ChatUser>[].obs;
  final FlutterSecureStorage storage = Get.find();
  final AuthController ac = Get.find();

  void getUsers(int chatId) async {
    try {
      loading(true);
      var url = Uri.parse("$serverUrl/Chats/users?chatId=$chatId");
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
        var userList = ChatUsersResponse.fromJson(jsonDecode(response.body));
        users.value = userList.chatUsers;
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
      newUserList.value = users.value;
    }
  }

  void addUserToChat(int chatId, String email) async {
    loading(true);
    try {
      var url =
          Uri.parse("$serverUrl/Chats/users/add?chatId=$chatId&email=$email");
      String token = '';
      await storage
          .read(key: 'jwt')
          .then((value) => {if (value != null) token = value});

      final response = await http.post(url, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        var userList = ChatUsersResponse.fromJson(jsonDecode(response.body));
        users.value = userList.chatUsers;
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
      newUserList.value = users.value;
    }
  }

  void getChatUsers(int chatId) async {
    try {
      var url = Uri.parse("$serverUrl/Chats/chatusers?chatId=$chatId");
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
        var newChatUserList =
            ChatUsersResponse.fromJson(jsonDecode(response.body));
        chatUserList.value = newChatUserList.chatUsers;
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  void deleteUserFromChat(int chatId, String email) async {
    try {
      var url = Uri.parse(
          "$serverUrl/Chats/users/delete?chatId=$chatId&email=$email");
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
        var newChatUserList =
            ChatUsersResponse.fromJson(jsonDecode(response.body));
        chatUserList.value = newChatUserList.chatUsers;
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  List<ChatUser> returnUsers() {
    return users.value;
  }
}
