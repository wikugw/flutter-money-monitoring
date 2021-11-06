import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:money_monitoring/app/utils/button_style.dart';
import 'package:money_monitoring/app/utils/drop_down_style.dart';
import 'package:money_monitoring/app/utils/text_field.dart';

import '../controllers/add_spending_controller.dart';

class AddSpendingView extends GetView<AddSpendingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        leadingWidth: 25,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Tambah Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            ListView(
              children: [
                TextField(
                  controller: controller.spentNameC,
                  decoration: TextFieldStyle.getTextFieldStyle(
                    'Nama Pengeluaran',
                    Icons.shopping_bag_rounded,
                  ),
                ),
                SizedBox(height: 15),
                DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  items: [
                    "Rumah tangga",
                    "Makanan/Minuman",
                    "Transportasi",
                    "Belanja",
                    "Pendidikan",
                    "Kesehatan",
                    "Perawatan",
                    "Investasi",
                    'Lain - lain'
                  ],
                  dropdownSearchDecoration:
                      DropDownSearchStyle.getDropDownSearchStyle(
                    'Jenis pengeluaran',
                  ),
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.spentTypeC.value = value;
                    }
                  },
                  selectedItem: controller.spentTypeC.value == ""
                      ? null
                      : controller.spentTypeC.value,
                ),
                SizedBox(height: 15),
                TextField(
                  controller: controller.priceC,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: TextFieldStyle.getTextFieldStyle(
                    'Total pengeluaran',
                    Icons.money,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Lampiran (Opsional)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 280,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: GetBuilder<AddSpendingController>(
                          builder: (c) => c.pickedImage != null
                              ? Container(
                                  height: 230,
                                  width: 230,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Container(
                                          height: 230,
                                          width: 230,
                                          child: Image(
                                            image: FileImage(
                                                File(c.pickedImage!.path)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          elevation: 2,
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.red,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                              onPressed: () => controller
                                                  .cancelAddAttachment(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Container(
                                    color: Color(0xFFF6F6F6),
                                    height: 230,
                                    width: 230,
                                    child: Center(
                                      child: Text('Upload'),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => controller.uploadFromGallery(),
                              icon: Icon(Icons.attach_file),
                              label: Text('Galeri'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff0071FF),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => controller.uploadFromCamera(),
                              icon: Icon(Icons.photo_camera),
                              label: Text('Foto'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xffF60470),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () => controller.addSpending(Get.arguments),
                  child: Text(
                    'Tambah',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: buttonStyle.getButtonStyle(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
