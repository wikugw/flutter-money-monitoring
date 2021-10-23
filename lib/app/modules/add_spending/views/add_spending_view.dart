import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/add_spending_controller.dart';

class AddSpendingView extends GetView<AddSpendingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('AddSpendingView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.spentNameC,
              decoration: InputDecoration(labelText: 'Nama pengeluaran'),
            ),
            SizedBox(height: 25),
            DropdownSearch<String>(
              mode: Mode.BOTTOM_SHEET,
              items: [
                "Kehidupan",
                "Makanan/Minuman",
                "Kebutuhan",
                'Lain - lain'
              ],
              label: "Jenis Pengeluaran",
              onChanged: (String? value) {
                if (value != null) {
                  controller.spentTypeC.value = value;
                }
              },
              selectedItem: controller.spentTypeC.value,
            ),
            SizedBox(height: 5),
            TextField(
              controller: controller.priceC,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total pengeluaran'),
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
                              onPressed: () => controller.cancelAddAttachment(),
                              child: Text('Batal'))
                        ],
                      )
                    : SizedBox(),
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => controller.addSpending(Get.arguments),
              child: Text('Tambah'),
            )
          ],
        ),
      ),
    );
  }
}
