import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_monitoring/app/routes/app_pages.dart';

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

    DocumentReference userDocRef =
        await firestore.collection('users').doc(params['loggedInEmail']);

    DocumentReference monthDocRef = await userDocRef
        .collection('moneyHistory')
        .doc(params['currentMonthId']);

    var dateNow = DateTime.now();
    String stringDateNow = dateNow.toIso8601String();
    String monthName = DateFormat.MMMM().format(dateNow);
    String dateNumber = DateFormat.d().format(dateNow);
    String year = DateFormat.y().format(dateNow);
    // untuk id document
    String UID = dateNumber + '-' + monthName + '-' + year;

    CollectionReference dateDocRef = await monthDocRef.collection('dates');

    QuerySnapshot todayDocRecord =
        await dateDocRef.where('dateNumber', isEqualTo: dateNumber).get();

    // tambah data hari ini ke DB
    if (todayDocRecord.docs.length == 0) {
      await dateDocRef.doc(UID).set(
          {"date": stringDateNow, "totalInDay": 0, "dateNumber": dateNumber});
    }

    DocumentReference currentDayDoc = await dateDocRef.doc(UID);
    // print(dateDocRef.get());

    // tambah record
    await currentDayDoc.collection('records').add({
      "spentName": spentNameC.text,
      "total": int.parse(priceC.text),
      "attachment": "",
      "createdAt": stringDateNow,
      "updatedAt": stringDateNow,
      "spentType": spentTypeC.value,
    });

    int spentInDay = 0;
    // mendapatkan total pengeluaran perhari
    await currentDayDoc.get().then((value) => spentInDay = value['totalInDay']);

    // pengeluaran yang diinput + total pengeluaran perhari
    await currentDayDoc
        .update({"totalInDay": spentInDay + int.parse(priceC.text)});

    // tambah pengeluaran perbulan
    int spentInMonth = 0;
    await monthDocRef
        .get()
        .then((value) => spentInMonth = value['totalInMonth']);
    await monthDocRef
        .update({"totalInMonth": spentInMonth + int.parse(priceC.text)});

    // tambah pengeluaran peruser
    int userSpent = 0;
    await userDocRef
        .get()
        .then((value) => userSpent = value['totalEntireSpent']);
    await userDocRef
        .update({"totalEntireSpent": userSpent + int.parse(priceC.text)});

    // dialog berhasil
    Get.defaultDialog(
      title: 'Berhasil',
      middleText: 'Berhasil menanmbah pengeluaran',
      onConfirm: () {
        Get.back();
        Get.offAllNamed(Routes.HOME);
      },
      textConfirm: 'Kembali ke halaman utama',
    );
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
