import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_monitoring/app/controllers/auth_controller.dart';
import 'package:money_monitoring/app/modules/home/data/models/pie_chart_model.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';
import 'package:money_monitoring/app/routes/app_pages.dart';
import 'package:money_monitoring/app/utils/number_format.dart';

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
              actions: [
                IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        Container(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text('Profile'),
                              ),
                              ListTile(
                                leading: Icon(Icons.logout),
                                title: Text('Keluar'),
                                onTap: () => authC.logout(),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.white,
                      );
                    },
                    icon: Icon(Icons.menu))
              ],
            ),
            body: Center(
                child: (currentMonthRecord?.dates == null)
                    ? Text(
                        'Tidak ada data',
                        style: TextStyle(fontSize: 20),
                      )
                    : (currentMonthRecord?.dates?.length == null ||
                            currentMonthRecord?.dates?.length == 0)
                        ? Center(
                            child:
                                Text('belum ada catatan pengeluaran bulan ini'),
                          )
                        : ListView(
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Halo, ${controller.user.value.name}!',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Pengeluaranmu bulan ini sebesar',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Rp. ${MoneyFormat.formatNumber(currentMonthRecord!.totalInMonth.toString())}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
                                child: Card(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: PieChart(
                                          PieChartData(
                                            borderData:
                                                FlBorderData(show: false),
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 40,
                                            sections: controller.spendTypeAll
                                                .asMap()
                                                .map<int, PieChartSectionData>(
                                                    (key, data) {
                                                  final value =
                                                      PieChartSectionData(
                                                    color: data.color,
                                                    value: data.percent,
                                                    title: '',
                                                    // radius: radius,
                                                    titleStyle: TextStyle(
                                                      // fontSize: fontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  );

                                                  return MapEntry(key, value);
                                                })
                                                .values
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: controller
                                                  .spendTypeAll.length,
                                              itemBuilder: (context, index) {
                                                PieDataModel data = controller
                                                    .spendTypeAll[index];
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1,
                                                      horizontal: 5),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                          radius: 5,
                                                          backgroundColor:
                                                              data.color),
                                                      SizedBox(width: 3),
                                                      Text('${data.name}')
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                      'Rincian Pengeluaran bulan ${currentMonthRecord.monthName}'),
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: currentMonthRecord.dates?.length,
                                  itemBuilder: (context, index) {
                                    var day = currentMonthRecord.dates?[index];
                                    // print(day);
                                    if (day!.records != null) {
                                      return ExpansionTile(
                                        title: Text(
                                            '${MoneyFormat.formatNumber(day.totalInDay.toString())}'),
                                        subtitle: Text(
                                          DateFormat.yMMMMd().format(
                                            DateTime.parse(day.date!),
                                          ),
                                        ),
                                        children: List.generate(
                                          day.records!.length,
                                          (index) => ListTile(
                                            title: Text(
                                                '${day.records![index].spentName}'),
                                            subtitle: Text(
                                                'Rp. ${MoneyFormat.formatNumber(day.records![index].total.toString())}'),
                                            trailing: IconButton(
                                              onPressed: () {
                                                // Get.delete<HomeController>();
                                                Get.toNamed(
                                                    Routes.EDIT_SPENDING,
                                                    arguments: {
                                                      "record":
                                                          day.records![index],
                                                      "loggedInEmail": authC
                                                          .user.value.email,
                                                      "currentMonthId":
                                                          currentMonthRecord.id,
                                                      "currentDateId": day.id,
                                                    });
                                              },
                                              icon: Icon(Icons.edit),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  }),
                            ],
                          )),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Get.toNamed(Routes.ADD_SPENDING, arguments: {
                "loggedInEmail": authC.user.value.email,
                "currentMonthId": currentMonthRecord!.id,
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
