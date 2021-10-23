import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditSpendingController extends GetxController {
  late TextEditingController spentNameC;
  late TextEditingController priceC;
  var spentTypeC = "".obs;
  var isImageChanged = false.obs;

  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage = null;

  void uploadFromCamera() async {
    try {
      isImageChanged.value = true;
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
      isImageChanged.value = true;
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
    isImageChanged.value = false;
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
