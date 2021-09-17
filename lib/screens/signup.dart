import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/models/auth_response.dart';
import 'package:get/get.dart';

class Signup extends StatelessWidget {
  final emailController = new TextEditingController();
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  final AuthController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Signup page"),
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
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
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
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
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
                  var username = usernameController.text;
                  var password = passwordController.text;

                  ac.signUp(username, email, password).then((value) => {
                        if (value is AuthResponse)
                          Get.toNamed('/')
                        else
                          Get.defaultDialog(middleText: value.message)
                      });

                  usernameController.clear();
                  emailController.clear();
                  passwordController.clear();
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Text('Already have an account? '),
            TextButton(
              onPressed: () {
                Get.toNamed("/login");
              },
              child: Text(
                'Log in',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
