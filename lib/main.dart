import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_client/bindings/home_binding.dart';
import 'package:flutter_client/screens/activities.dart';
import 'package:flutter_client/screens/home.dart';
import 'package:flutter_client/screens/login.dart';
import 'package:flutter_client/screens/search_babysitters.dart';
import 'package:flutter_client/screens/signup.dart';
import 'package:get/get.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
 
void main(){
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
        GetPage(name: '/activities', page: () => Activities()),
        GetPage(name: '/searchBabysitters', page: () => SearchBabysitters())
      ],
    );
  }
}
