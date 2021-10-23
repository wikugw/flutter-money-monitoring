import 'dart:io';

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
    String loggedInEmail = Get.arguments['loggedInEmail'];
    String currentMonthId = Get.arguments['currentMonthId'];
    String currentDateId = Get.arguments['currentDateId'];

    var dateNow = DateTime.now();
    String stringDateNow = dateNow.toIso8601String();

    String photoUrl = record.attachment!;
    if (pickedImage != null) {
      try {
        Reference storageRef = await storage.ref(
            "${loggedInEmail}/${currentMonthId}/${currentDateId}/${stringDateNow}-${loggedInEmail}.${pickedImage!.name.split('.').last}");
        File file = File(pickedImage!.path);

        await storageRef.putFile(file);
        photoUrl = await storageRef.getDownloadURL();
        // delete gambar
      } catch (e) {
        print(e);
      }
    }
    print(photoUrl);
    // cancelAddAttachment();

    // update ke DB
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
