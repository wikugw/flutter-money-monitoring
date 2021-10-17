import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user = UserModel().obs;
  var currentMonthRecord = MoneyHistory().obs;

  Future<MoneyHistory> getCurrentMonthRecord(String loggedInEmail) async {
    CollectionReference users = firestore.collection('users');

    var dateNow = DateTime.now();

    String monthNumber = DateFormat.M().format(dateNow);
    String year = DateFormat.y().format(dateNow);

    final currentUser = await users.doc(loggedInEmail).get();
    final currentUserData = currentUser.data() as Map<String, dynamic>;
    final moneyHistoryRef = await users
        .doc(loggedInEmail)
        .collection('moneyHistory')
        .where('month', isEqualTo: monthNumber)
        .where('year', isEqualTo: year)
        .get();

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

    user(UserModel.fromJson(currentUserData));
    user.refresh();

    user.update((val) {
      val!.moneyHistory = moneyHistoryList;
    });

    if (user.value.moneyHistory != null) {
      for (var element in user.value.moneyHistory!) {
        if (element.month == monthNumber && element.year == year) {
          currentMonthRecord.value = element;

          QuerySnapshot currentMonthDateRecord = await users
              .doc(loggedInEmail)
              .collection('moneyHistory')
              .doc(currentMonthRecord.value.id)
              .collection('dates')
              .get();

          List<Dates> DatePerMonthHistoryList = [];
          if (currentMonthDateRecord.docs.length > 0) {
            currentMonthDateRecord.docs.forEach((element) {
              // todo - memasukkan pembelian ke tiap hari

              // List<Dates> SpentItemPerDay = [];
              // if (currentMonthDateRecord.docs.length > 0) {
              //   currentMonthDateRecord.docs.forEach((element) {
              //     var dateRecord = element.data() as Map<String, dynamic>;
              //     DatePerMonthHistoryList.add(
              //       Dates(
              //         date: dateRecord['date'],
              //         totalInDay: dateRecord['totalInDay'],
              //       ),
              //     );
              //   });
              // }

              var dateRecord = element.data() as Map<String, dynamic>;
              DatePerMonthHistoryList.add(
                Dates(
                  date: dateRecord['date'],
                  totalInDay: dateRecord['totalInDay'],
                ),
              );
            });
          }

          currentMonthRecord.update((val) {
            val!.dates = DatePerMonthHistoryList;
          });
        }
      }
    }
    return currentMonthRecord.value;

    // return user.value;
  }
}
