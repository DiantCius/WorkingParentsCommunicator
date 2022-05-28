import 'dart:convert';

import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/controllers/users_controller.dart';
import 'package:flutter_client/main.dart';
import 'package:flutter_client/models/message.dart';
import 'package:flutter_client/models/messages_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MessagesController extends GetxController {
  var loading = true.obs;
  var messages = <Message>[].obs;
  var messageList = <Message>[].obs;
  var count = 0.obs;
  final FlutterSecureStorage storage = Get.find();
  final AuthController ac = Get.find();
  final UsersController uc = Get.find();

  void getMessages(int chatId) async {
    try {
      loading(true);
      var url = Uri.parse("$serverUrl/Chats/messages?chatId=$chatId");
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
        var oldMessageList =
            MessagesResponse.fromJson(jsonDecode(response.body));
        messageList.value = oldMessageList.messages;
        for (var message in messageList) {
          message.isMine = message.name == uc.currentUser.value.username;
        }
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
    } finally {
      loading(false);
    }
  }

  void createMessage(String text, int chatId) async {
    try {
      var url =
          Uri.parse("$serverUrl/Chats/messages/add?text=$text&chatId=$chatId");
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
        print("git");
      }
      if (response.statusCode == 401) {
        ac.logOut();
        Get.toNamed("/login");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
