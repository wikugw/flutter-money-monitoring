import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_monitoring/app/controllers/auth_controller.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginView'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(color: Colors.black),
            ),
            onPressed: () => authC.gmailLogin(),
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/logo/google.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        'Login dengan akun google',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
