import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:money_monitoring/app/routes/app_pages.dart';
import 'package:random_string/random_string.dart';

class AddSpendingController extends GetxController {
  late TextEditingController spentNameC;
  late TextEditingController priceC;
  var spentTypeC = "".obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage = null;

  void uploadFromCamera() async {
    try {
      final XFile? checkImageData =
          await imagePicker.pickImage(source: ImageSource.camera);

      if (checkImageData != null) {
        pickedImage = checkImageData;
        update();
      }
    } catch (e) {
      Get.defaultDialog(title: 'Gagal ambil gambar', middleText: '$e');
    }
  }

  void uploadFromGallery() async {
    try {
      final XFile? checkImageData =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (checkImageData != null) {
        pickedImage = checkImageData;
        update();
      }
    } catch (e) {
      Get.defaultDialog(title: 'Gagal unggah gambar', middleText: '$e');
    }
  }

  void cancelAddAttachment() {
    pickedImage = null;
    update();
  }

  Future<void> addSpending(params) async {
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
      await dateDocRef.doc(UID).set({
        "id": UID,
        "date": stringDateNow,
        "totalInDay": 0,
        "dateNumber": dateNumber
      });
    }

    DocumentReference currentDayDoc = await dateDocRef.doc(UID);

    // upload gambar ke DB
    String photoUrl = "";
    if (pickedImage != null) {
      try {
        Reference storageRef = await storage.ref(
            "${params['loggedInEmail']}/${params['currentMonthId']}/${UID}/${stringDateNow}-${params['loggedInEmail']}.${pickedImage!.name.split('.').last}");
        File file = File(pickedImage!.path);

        await storageRef.putFile(file);
        photoUrl = await storageRef.getDownloadURL();
        cancelAddAttachment();
      } catch (e) {
        print(e);
      }
    }

    String recordId = UID + '-' + randomAlphaNumeric(10);

    // tambah record
    await currentDayDoc.collection('records').doc(recordId).set({
      "id": recordId,
      "spentName": spentNameC.text,
      "total": int.parse(priceC.text),
      "attachment": photoUrl,
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
      confirmTextColor: Colors.white,
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
