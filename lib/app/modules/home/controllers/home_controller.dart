import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user = UserModel().obs;
  MoneyHistory currentMonthRecord = MoneyHistory();

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

    user.value.moneyHistory?.forEach((element) {
      if (element.month == monthNumber && element.year == year) {
        currentMonthRecord = element;
      }
    });
    return currentMonthRecord;

    // return user.value;
  }
}
