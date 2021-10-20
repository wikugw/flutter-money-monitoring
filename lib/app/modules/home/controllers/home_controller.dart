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

    try {
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
              for (var dayInMonthElement in currentMonthDateRecord.docs) {
                print(dayInMonthElement.id);
                int day = 0;

                var dateRecord =
                    dayInMonthElement.data() as Map<String, dynamic>;
                print(dateRecord);
                DatePerMonthHistoryList.add(
                  Dates(
                    date: dateRecord['date'],
                    totalInDay: dateRecord['totalInDay'],
                  ),
                );

                QuerySnapshot currentRecordPerDay = await users
                    .doc(loggedInEmail)
                    .collection('moneyHistory')
                    .doc(currentMonthRecord.value.id)
                    .collection('dates')
                    .doc(dayInMonthElement.id)
                    .collection('records')
                    .get();

                print('---- panjang item dibeli perhari');
                print(currentRecordPerDay.docs.length);

                List<Records> SpentItemPerDay = [];
                if (currentRecordPerDay.docs.length > 0) {
                  print('ngecek pembelian perhari');
                  for (var item in currentRecordPerDay.docs) {
                    print(day);
                    print('--record item perhari');
                    print(DatePerMonthHistoryList[day].totalInDay);
                    var itemRecord = item.data() as Map<String, dynamic>;
                    print(itemRecord);
                    SpentItemPerDay.add(Records(
                      spentName: itemRecord['spentName'],
                      spentType: itemRecord['spentType'],
                      total: itemRecord['total'],
                      attachment: itemRecord['attachment'],
                      createdAt: itemRecord['createdAt'],
                      updatedAt: itemRecord['updatedAt'],
                    ));
                  }
                  Dates haha = DatePerMonthHistoryList[day];
                  haha.records = SpentItemPerDay;
                  print(haha.records);
                }
                day++;
              }
            }

            currentMonthRecord.update((val) {
              val!.dates = DatePerMonthHistoryList;
            });
          }
        }
      }
      return currentMonthRecord.value;
    } catch (e) {
      print(e);
      return currentMonthRecord.value;
    }

    // return user.value;
  }
}
