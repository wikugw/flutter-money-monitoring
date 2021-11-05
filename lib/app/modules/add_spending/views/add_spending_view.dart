import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
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
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Tambah Pengeluaran',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
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
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Lampiran (Opsional)'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton.icon(
                            onPressed: () => controller.uploadFromGallery(),
                            icon: Icon(Icons.attach_file),
                            label: Text('Ambil dari galeri'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton.icon(
                            onPressed: () => controller.uploadFromCamera(),
                            icon: Icon(Icons.photo_camera),
                            label: Text('Ambil foto'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: GetBuilder<AddSpendingController>(
                    builder: (c) => c.pickedImage != null
                        ? Column(
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                child: Image(
                                  image: FileImage(File(c.pickedImage!.path)),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () =>
                                      controller.cancelAddAttachment(),
                                  child: Text('Batal'))
                            ],
                          )
                        : SizedBox(),
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
                  style: ElevatedButton.styleFrom(
                    // primary: Color(0xFF0071FF),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
