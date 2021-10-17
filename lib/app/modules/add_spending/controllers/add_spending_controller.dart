import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddSpendingController extends GetxController {
  late TextEditingController spentNameC;
  late TextEditingController priceC;
  var spentTypeC = "".obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addSpending(params) async {
    print(spentTypeC);
    print(spentNameC.text);
    print(priceC.text);
    print(params['loggedInEmail']);
    print(params['currentMonthId']);

    var dateNow = DateTime.now();
    String stringDateNow = dateNow.toIso8601String();
    String monthName = DateFormat.MMMM().format(dateNow);
    String monthNumber = DateFormat.M().format(dateNow);
    String dateNumber = DateFormat.M().format(dateNow);
    String year = DateFormat.y().format(dateNow);
    // untuk id document
    String UID = dateNumber + '-' + monthName + '-' + year;
    print(UID);

    QuerySnapshot todayDocRecord = await firestore
        .collection('users')
        .doc(params['loggedInEmail'])
        .collection('moneyHistory')
        .doc(params['currentMonthId'])
        .collection('dates')
        .where('date', isEqualTo: stringDateNow)
        .get();

    // tambah data hari ini ke DB
    if (todayDocRecord.docs.length == 0) {
      await firestore
          .collection('users')
          .doc(params['loggedInEmail'])
          .collection('moneyHistory')
          .doc(params['currentMonthId'])
          .collection('dates')
          .doc(UID)
          .set({"date": stringDateNow, "totalInDay": 0});
    }
  }

  @override
  void onInit() {
    spentNameC = TextEditingController();
    priceC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    spentNameC.dispose();
    priceC.dispose();
    super.onClose();
  }
}
