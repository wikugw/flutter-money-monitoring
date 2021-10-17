import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
          print('di view');
          print(currentMonthRecord!.dates?.length);
          return Scaffold(
            appBar: AppBar(
              title: Text('HomeView'),
              centerTitle: true,
            ),
            body: Center(
              child: (currentMonthRecord.dates == null)
                  ? Text(
                      'Tidak ada data',
                      style: TextStyle(fontSize: 20),
                    )
                  : ListView.builder(
                      itemCount: currentMonthRecord.dates?.length,
                      itemBuilder: (context, index) {
                        var day = currentMonthRecord.dates?[index];
                        return ExpansionTile(
                          title: Text('${day!.totalInDay}'),
                          subtitle: Text(
                            DateFormat.yMMMMd().format(
                              DateTime.parse(day.date!),
                            ),
                          ),
                          // children: List.generate(
                          //   day.records!.length,
                          //   (index) => Text('data'),
                          // ),
                        );
                      }),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.toNamed(Routes.ADD_SPENDING, arguments: {
                "loggedInEmail": authC.user.value.email,
                "currentMonthId": currentMonthRecord.id,
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
