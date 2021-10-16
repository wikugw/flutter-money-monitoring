import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_monitoring/app/controllers/auth_controller.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LoginView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () => authC.gmailLogin()),
    );
  }
}
