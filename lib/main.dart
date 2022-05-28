import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_client/bindings/home_binding.dart';
import 'package:flutter_client/screens/activities.dart';
import 'package:flutter_client/screens/babysitters.dart';
import 'package:flutter_client/screens/chat.dart';
import 'package:flutter_client/screens/chats.dart';
import 'package:flutter_client/screens/forgot_password.dart';
import 'package:flutter_client/screens/home.dart';
import 'package:flutter_client/screens/invitations.dart';
import 'package:flutter_client/screens/login.dart';
import 'package:flutter_client/screens/search_babysitters.dart';
import 'package:flutter_client/screens/search_chat_users.dart';
import 'package:flutter_client/screens/signup.dart';
import 'package:get/get.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//final serverUrl = "http://192.168.43.141:5001";
//final serverUrl = "http://10.0.2.2:5000";
final serverUrl = "https://parents-communicator.herokuapp.com";

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Home(), binding: HomeBinding()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/signup', page: () => Signup()),
        GetPage(name: '/forgotPassword', page: () => ForgotPassword()),
        GetPage(name: '/activities', page: () => Activities()),
        GetPage(name: '/searchBabysitters', page: () => SearchBabysitters()),
        GetPage(name: '/babysitters', page: () => Babysitters()),
        GetPage(name: '/invitations', page: () => Invitations()),
        GetPage(name: '/chat', page: () => Chat()),
        GetPage(name: '/chats', page: () => Chats()),
        GetPage(name: '/searchChatUsers', page: () => SearchChatUsers()),
      ],
    );
  }
}
