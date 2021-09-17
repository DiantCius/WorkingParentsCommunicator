import 'package:flutter_client/models/auth_response.dart';
import 'package:flutter_client/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;
  var token = "".obs;
  final FlutterSecureStorage storage = Get.put(FlutterSecureStorage());
  //final FlutterSecureStorage storage = Get.find();

  Future logIn(String email, String password) async {
    var response = await AuthService.attemptLogIn(email, password);
    if (response is AuthResponse) {
      //token(response.user.token);
      storage.write(key: 'jwt', value: response.user.token);
      isLoggedIn(true);
      return response;
    } else {
      isLoggedIn(false);
      return response;
    }
  }

  Future signUp(String username, String email, String password) async {
    var response = await AuthService.attemptSignUp(username, email, password);
    if (response is AuthResponse) {
      //token(response.user.token);
      storage.write(key: 'jwt', value: response.user.token);
      isLoggedIn(true);
      return response;
    } else {
      isLoggedIn(false);
      return response;
    }
  }

  void logOut() async {
    await storage.delete(key: 'jwt');
    isLoggedIn(false);
    //token('');
  }
}
