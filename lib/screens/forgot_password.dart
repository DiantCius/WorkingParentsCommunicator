import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/models/error_response.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final emailController = new TextEditingController();
  final AuthController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What \'s my password?'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  height: 150,
                ),
              ),
            ),
            Text(
              "Email address",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                ac.forgotPassword(emailController.text).then((value) => {
                      if (value is ErrorResponse)
                        Get.defaultDialog(middleText: value.message)
                      else
                        {
                          Get.back(),
                          Get.defaultDialog(
                              middleText: "New password was sent on your email")
                        }
                    });
                emailController.clear();
              },
              child: Text(
                'Reset Password',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            Container(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
