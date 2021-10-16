import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_monitoring/app/controllers/auth_controller.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: controller.getCurrentMonthRecord(authC.user.value.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var moneyHistoryList = snapshot.data!.moneyHistory;
            print(controller.currentMonthRecord.monthName);
            return Scaffold(
              appBar: AppBar(
                title: Text('HomeView'),
                centerTitle: true,
              ),
              body: Center(
                child: Text(
                  'HomeView is working',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
