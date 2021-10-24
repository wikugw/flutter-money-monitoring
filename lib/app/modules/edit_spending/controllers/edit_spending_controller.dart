import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';

class EditSpendingController extends GetxController {
  late TextEditingController spentNameC;
  late TextEditingController priceC;
  var spentTypeC = "".obs;
  var isImageChanged = false.obs;

  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage = null;

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void uploadFromCamera() async {
    try {
      final XFile? checkImageData =
          await imagePicker.pickImage(source: ImageSource.camera);

      if (checkImageData != null) {
        pickedImage = checkImageData;
        update();
        isImageChanged.value = true;
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
        isImageChanged.value = true;
      }
    } catch (e) {
      Get.defaultDialog(title: 'Gagal unggah gambar', middleText: '$e');
    }
  }

  void cancelAddAttachment() {
    isImageChanged.value = false;
    pickedImage = null;
  }

  Future<void> updateSpending(params) async {
    Records record = Get.arguments['record'];
    String recordId = record.id!;
    String loggedInEmail = Get.arguments['loggedInEmail'];
    String currentMonthId = Get.arguments['currentMonthId'];
    String currentDateId = Get.arguments['currentDateId'];

    var dateNow = DateTime.now();
    String stringDateNow = dateNow.toIso8601String();

    String photoUrl = record.attachment!;
    String oldPhoto = photoUrl;
    if (pickedImage != null) {
      try {
        Reference storageRef = await storage.ref(
            "${loggedInEmail}/${currentMonthId}/${currentDateId}/${stringDateNow}-${loggedInEmail}.${pickedImage!.name.split('.').last}");
        File file = File(pickedImage!.path);

        await storageRef.putFile(file);
        photoUrl = await storageRef.getDownloadURL();
        // delete gambar
        FirebaseStorage.instance.refFromURL(oldPhoto).delete();
      } catch (e) {
        print(e);
      }
    }

    int oldTotal = record.total!;

    DocumentReference userDoc =
        await firestore.collection('users').doc(loggedInEmail);
    DocumentReference monthDoc =
        await userDoc.collection('moneyHistory').doc(currentMonthId);
    DocumentReference dateDoc =
        await monthDoc.collection('dates').doc(currentDateId);
    DocumentReference recordDoc =
        await dateDoc.collection('records').doc(recordId);

    if (oldTotal != int.parse(priceC.text)) {
      int spentInDay = 0;
      // mendapatkan total pengeluaran perhari
      await dateDoc.get().then((value) => spentInDay = value['totalInDay']);

      // mengurangi pengeluaran perhari dengan pengeluaran lama, kemudian ditambah dengan yang baru
      await dateDoc.update(
          {"totalInDay": (spentInDay - oldTotal) + int.parse(priceC.text)});

      // tambah pengeluaran perbulan
      int spentInMonth = 0;
      await monthDoc
          .get()
          .then((value) => spentInMonth = value['totalInMonth']);
      await monthDoc.update(
          {"totalInMonth": (spentInMonth - oldTotal) + int.parse(priceC.text)});

      // tambah pengeluaran peruser
      int userSpent = 0;
      await userDoc
          .get()
          .then((value) => userSpent = value['totalEntireSpent']);
      await userDoc.update({
        "totalEntireSpent": (userSpent - oldTotal) + int.parse(priceC.text)
      });
    }

    // update ke DB
    var currRecord = await recordDoc.update({
      "spentName": spentNameC.text,
      "total": int.parse(priceC.text),
      "attachment": photoUrl,
      "updatedAt": stringDateNow,
      "spentType": spentTypeC.value,
    });
    // coba akses controller home, update data
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
