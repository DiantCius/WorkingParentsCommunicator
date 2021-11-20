import 'package:flutter_client/controllers/activities_controller.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/controllers/babysitters_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/controllers/invitations_controller.dart';
import 'package:flutter_client/controllers/users_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    //Get.put(FlutterSecureStorage());
    Get.put<ActivitiesController>(ActivitiesController());
    //Get.lazyPut(() => ActivitiesController());
    Get.put <ChildrenController>(ChildrenController());
    Get.put <BabysittersController>(BabysittersController());
    Get.put <UsersController>(UsersController());
    Get.put <InvitationsController>(InvitationsController());
  }
}
