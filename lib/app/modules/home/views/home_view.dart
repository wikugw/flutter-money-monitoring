import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_monitoring/app/controllers/auth_controller.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';
import 'package:money_monitoring/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MoneyHistory>(
      future: controller.getCurrentMonthRecord(authC.user.value.email!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var currentMonthRecord = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('HomeView'),
              centerTitle: true,
            ),
            body: Center(
              child: (currentMonthRecord!.dates == null)
                  ? Text(
                      'Tidak ada data',
                      style: TextStyle(fontSize: 20),
                    )
                  : Text(
                      'ada data',
                      style: TextStyle(fontSize: 20),
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.toNamed(Routes.ADD_SPENDING, arguments: {
                authC.user.value.email,
              }),
            ),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
