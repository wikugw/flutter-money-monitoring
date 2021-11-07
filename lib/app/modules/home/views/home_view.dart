import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
            backgroundColor: Color(0xFFF6F6F6),
            body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: (currentMonthRecord?.dates?.length == null ||
                              currentMonthRecord?.dates?.length == 0)
                          ? Center(
                              child: Text(
                                  'belum ada catatan pengeluaran bulan ini'),
                            )
                          : ListView(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(6, 0, 14, 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Selamat datang, \n${controller.user.value.name}!',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.bottomSheet(
                                            Container(
                                              child: Wrap(
                                                children: [
                                                  ListTile(
                                                    leading: Icon(Icons.person),
                                                    title: Text(
                                                      'Profile',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    leading: Icon(Icons.logout),
                                                    title: Text(
                                                      'Keluar',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () => authC.logout(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundImage: NetworkImage(
                                              controller.user.value.photoUrl!),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pengeluaranmu bulan ini sebesar',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Rp. ${MoneyFormat.formatNumber(currentMonthRecord!.totalInMonth.toString())}',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 30,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Text(
                                            'Pengeluaranmu bulan ini untuk keperluan...',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Container(
                                            height: 220,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: PieChart(
                                                    PieChartData(
                                                      borderData: FlBorderData(
                                                          show: false),
                                                      sectionsSpace: 0,
                                                      centerSpaceRadius: 40,
                                                      sections: controller
                                                          .spendTypeAll
                                                          .asMap()
                                                          .map<int,
                                                                  PieChartSectionData>(
                                                              (key, data) {
                                                            final value =
                                                                PieChartSectionData(
                                                              color: data.color,
                                                              value:
                                                                  data.percent,
                                                              title: '',
                                                              // radius: radius,
                                                              titleStyle:
                                                                  TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                // fontSize: fontSize,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );

                                                            return MapEntry(
                                                                key, value);
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
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: controller
                                                            .spendTypeAll
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          PieDataModel data =
                                                              controller
                                                                      .spendTypeAll[
                                                                  index];

                                                          return Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 1,
                                                                    horizontal:
                                                                        5),
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                    radius: 5,
                                                                    backgroundColor:
                                                                        data.color),
                                                                SizedBox(
                                                                    width: 3),
                                                                Text(
                                                                  '${data.name}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'Rincian Pengeluaran bulan ${currentMonthRecord.monthName}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 80.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount:
                                          currentMonthRecord.dates?.length,
                                      itemBuilder: (context, index) {
                                        var day =
                                            currentMonthRecord.dates?[index];
                                        // print(day);
                                        if (day!.records != null) {
                                          return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: ExpansionTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.primaries[Random()
                                                        .nextInt(Colors
                                                            .primaries.length)],
                                                child: Text(
                                                  '${day.records!.length}',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                'Rp. ${MoneyFormat.formatNumber(day.totalInDay.toString())}',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                DateFormat.yMMMMd().format(
                                                  DateTime.parse(day.date!),
                                                ),
                                                style: TextStyle(
                                                    fontFamily: 'Roboto'),
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
                                                                day.records![
                                                                    index],
                                                            "loggedInEmail":
                                                                authC.user.value
                                                                    .email,
                                                            "currentMonthId":
                                                                currentMonthRecord
                                                                    .id,
                                                            "currentDateId":
                                                                day.id,
                                                          });
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      }),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                        height: 70,
                        child: Card(
                          color: Color(0xff0071FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Center(
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.home,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // color: Colors.amber,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () => Get.toNamed(
                                          Routes.ADD_SPENDING,
                                          arguments: {
                                            "loggedInEmail":
                                                authC.user.value.email,
                                            "currentMonthId":
                                                currentMonthRecord!.id,
                                          }),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Center(
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
