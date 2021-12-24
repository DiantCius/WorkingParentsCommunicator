import 'package:flutter_client/controllers/activities_controller.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/controllers/babysitters_controller.dart';
import 'package:flutter_client/controllers/chat_users_controller.dart';
import 'package:flutter_client/controllers/chats_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/controllers/home_controller.dart';
import 'package:flutter_client/controllers/invitations_controller.dart';
import 'package:flutter_client/controllers/messages_controller.dart';
import 'package:flutter_client/controllers/users_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<ActivitiesController>(ActivitiesController());
    Get.put<ChildrenController>(ChildrenController());
    Get.put<BabysittersController>(BabysittersController());
    Get.put<UsersController>(UsersController());
    Get.put<InvitationsController>(InvitationsController());
    Get.put<ChatsController>(ChatsController());
    Get.put<MessagesController>(MessagesController());
    Get.put<ChatUsersController>(ChatUsersController());
    Get.put<HomeController>(HomeController());

    /*Get.lazyPut(() => AuthController());
    Get.lazyPut(() => ActivitiesController());
    Get.lazyPut(() => ChildrenController());
    Get.lazyPut(() => BabysittersController());
    Get.lazyPut(() => UsersController());
    Get.lazyPut(() => InvitationsController());
    Get.lazyPut(() => ChatsController());
    Get.lazyPut(() => MessagesController());
    Get.lazyPut(() => ChatUsersController());*/
  }
}
