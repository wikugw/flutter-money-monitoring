import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_monitoring/app/modules/home/data/models/pie_chart_model.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';
import 'package:money_monitoring/app/utils/notification_manager.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user = UserModel().obs;
  var currentMonthRecord = MoneyHistory().obs;
  List<String> spendTypeName = [];
  List<PieDataModel> spendTypeAll = [];

  Future<void> sendReminderNotification() async {
    await notificationManager.scheduledNotification();
    Get.defaultDialog(
      title: 'Reminder berhasil dibuat',
      middleText: 'Reminder akan muncul 10 menit lagi berupa notifikasi',
      onConfirm: () => Get.back(),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
    );
  }

  Future<MoneyHistory> getCurrentMonthRecord(String loggedInEmail) async {
    // generate firestore collection user
    CollectionReference users = firestore.collection('users');

    // generate string dari date
    var dateNow = DateTime.now();
    String monthNumber = DateFormat.M().format(dateNow);
    String year = DateFormat.y().format(dateNow);

    // get bulan sekarang
    final currentUser = await users.doc(loggedInEmail).get();
    final currentUserData = currentUser.data() as Map<String, dynamic>;
    final moneyHistoryRef = await users
        .doc(loggedInEmail)
        .collection('moneyHistory')
        .where('month', isEqualTo: monthNumber)
        .where('year', isEqualTo: year)
        .get();

    // jika datanya ada (harusnya hanya 1) akan ditambahkan ke model MoneyHistory
    // bulan ini
    List<MoneyHistory> moneyHistoryList = [];
    if (moneyHistoryRef.docs.length > 0) {
      moneyHistoryRef.docs.forEach((element) {
        var moneyHistory = element.data();
        moneyHistoryList.add(MoneyHistory(
          id: moneyHistory['id'],
          year: moneyHistory['year'],
          month: moneyHistory['month'],
          monthName: moneyHistory['monthName'],
          totalInMonth: moneyHistory['totalInMonth'],
        ));
      });
    }

    // data user login dari FB akan dimasukkan ke model user
    user(UserModel.fromJson(currentUserData));
    user.refresh();

    // update data perbulan ke model user
    user.update((val) {
      val!.moneyHistory = moneyHistoryList;
    });

    try {
      // kalau value bulan ini tidak null
      if (user.value.moneyHistory != null) {
        for (var element in user.value.moneyHistory!) {
          // jika month dan year sama dengan sekarang maka akan dimasukkan ke model
          // currentmonthrecord (yang akan di return)
          if (element.month == monthNumber && element.year == year) {
            currentMonthRecord.value = element;

            // ambil data perhari dari bulan sekarang
            QuerySnapshot currentMonthDateRecord = await users
                .doc(loggedInEmail)
                .collection('moneyHistory')
                .doc(currentMonthRecord.value.id)
                .collection('dates')
                .orderBy('dateNumber', descending: true)
                .get();

            List<Dates> DatePerMonthHistoryList = [];

            // jika ada hari (telah input pengeluaran pada hari itu)
            if (currentMonthDateRecord.docs.length > 0) {
              // perulangan perhari
              int day = 0;
              for (var dayInMonthElement in currentMonthDateRecord.docs) {
                // ambil record pengeluaran perhari
                var dateRecord =
                    dayInMonthElement.data() as Map<String, dynamic>;
                DatePerMonthHistoryList.add(
                  Dates(
                    id: dateRecord['id'],
                    date: dateRecord['date'],
                    totalInDay: dateRecord['totalInDay'],
                  ),
                );

                // ambil record pengeluaran perhari
                QuerySnapshot currentRecordPerDay = await users
                    .doc(loggedInEmail)
                    .collection('moneyHistory')
                    .doc(currentMonthRecord.value.id)
                    .collection('dates')
                    .doc(dayInMonthElement.id)
                    .collection('records')
                    .get();

                List<Records> SpentItemPerDay = [];

                // cek jika ada pengeluaran, masukkan data pengeluaran dari FB
                // ke model records
                if (currentRecordPerDay.docs.length > 0) {
                  for (var item in currentRecordPerDay.docs) {
                    var itemRecord = item.data() as Map<String, dynamic>;
                    String spendType = itemRecord['spentType'];
                    SpentItemPerDay.add(Records(
                      id: itemRecord['id'],
                      spentName: itemRecord['spentName'],
                      spentType: spendType,
                      total: itemRecord['total'],
                      attachment: itemRecord['attachment'],
                      createdAt: itemRecord['createdAt'],
                      updatedAt: itemRecord['updatedAt'],
                    ));

                    // buat list type apa aja yang ada
                    if (!spendTypeName.contains(spendType)) {
                      spendTypeName.add(spendType);
                      spendTypeAll.add(PieDataModel(name: spendType));
                    }
                  }
                  // ambil hari yang sedang di loopig (dari hari/bulan)
                  // tambahkan list model pengeluaran perhari ke hari tsb
                  Dates perDay = DatePerMonthHistoryList[day];
                  perDay.records = SpentItemPerDay;
                }
                day = day + 1;
              }
            }

            currentMonthRecord.update((val) {
              val!.dates = DatePerMonthHistoryList;
            });

            // berdasarkan list type, ditambahkan pengeluaran ke masing" tipe
            if (spendTypeAll.length > 0) {
              spendTypeAll.forEach((PieDataModel typeEl) {
                currentMonthRecord.value.dates!.forEach((dayEl) {
                  dayEl.records?.forEach((recEl) {
                    if (recEl.spentType == typeEl.name) {
                      typeEl.updateTotalPrice(recEl.total!);
                    }
                  });
                });
                typeEl.updatePercentage(currentMonthRecord.value.totalInMonth!);
                typeEl.setColor();
              });
            }
          }
        }
      }
      return currentMonthRecord.value;
    } catch (e) {
      print(e);
      return currentMonthRecord.value;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
