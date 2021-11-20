import 'dart:convert';

import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/models/invitation.dart';
import 'package:flutter_client/models/invitations_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InvitationsController extends GetxController
{
  var loading = true.obs;
  var invitations = <Invitation>[].obs;
  var count = 0.obs;
  var currentInvitation = Invitation().obs;
  final FlutterSecureStorage storage = Get.find();
  final AuthController ac = Get.find();


  void getInvitations() async {
    try {
      loading(true);
      var url = Uri.parse("http://10.0.2.2:5000/Invitations");
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
        var invitationList = InvitationsResponse.fromJson(jsonDecode(response.body));
        invitations.value = invitationList.invitations;
        count.value = invitationList.count;
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
}

