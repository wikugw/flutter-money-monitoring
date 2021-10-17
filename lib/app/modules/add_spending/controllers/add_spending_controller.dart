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
    // print(spentTypeC);
    // print(spentNameC.text);
    // print(priceC.text);
    // print(params['loggedInEmail']);
    // print(params['currentMonthId']);

    DocumentReference monthDocRef = firestore
        .collection('users')
        .doc(params['loggedInEmail'])
        .collection('moneyHistory')
        .doc(params['currentMonthId']);

    var dateNow = DateTime.now();
    String stringDateNow = dateNow.toIso8601String();
    String monthName = DateFormat.MMMM().format(dateNow);
    String dateNumber = DateFormat.M().format(dateNow);
    String year = DateFormat.y().format(dateNow);
    // untuk id document
    String UID = dateNumber + '-' + monthName + '-' + year;

    CollectionReference dateDocRef = monthDocRef.collection('dates');

    QuerySnapshot todayDocRecord =
        await dateDocRef.where('date', isEqualTo: stringDateNow).get();

    // tambah data hari ini ke DB
    if (todayDocRecord.docs.length == 0) {
      await dateDocRef.doc(UID).set({"date": stringDateNow, "totalInDay": 0});
    }

    DocumentReference currentDayDoc = dateDocRef.doc(UID);

    // tambah record
    await currentDayDoc.collection('records').add({
      "spentName": spentNameC.text,
      "total": int.parse(priceC.text),
      "attachment": "",
      "createdAt": stringDateNow,
      "updatedAt": stringDateNow
    });

    int spentInDay = 0;
    // mendapatkan total pengeluaran perhari
    await currentDayDoc.get().then((value) => spentInDay = value['totalInDay']);

    // pengeluaran yang diinput + total pengeluaran perhari
    await currentDayDoc
        .update({"totalInDay": spentInDay + int.parse(priceC.text)});

    // tambah pengeluaran perbulan
    // tambah pengeluaran peruser
    // dialog berhasil
    // return ke home
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
