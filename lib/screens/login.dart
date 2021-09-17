import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/models/auth_response.dart';
import 'package:flutter_client/services/auth_service.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  final AuthController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                ),
              ),
            ),
            //Obx(() => Text(ac.token.toString())),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  var email = emailController.text;
                  var password = passwordController.text;

                  ac.logIn(email, password).then((value) => {
                        if (value is AuthResponse)
                          {Get.toNamed('/')}
                        else
                          Get.defaultDialog(middleText: value.message)
                      });
                  emailController.clear();
                  passwordController.clear();
                },
                child: Text(
                  'Login ',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Text('New User? '),
            TextButton(
              onPressed: () {
                Get.toNamed("/signup");
              },
              child: Text(
                'Create Account',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
