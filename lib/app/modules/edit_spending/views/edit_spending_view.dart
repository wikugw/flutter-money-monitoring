import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';
import 'package:money_monitoring/app/routes/app_pages.dart';

import '../controllers/edit_spending_controller.dart';

class EditSpendingView extends GetView<EditSpendingController> {
  @override
  Widget build(BuildContext context) {
    Records record = Get.arguments['record'];
    // String loggedInEmail = Get.arguments['loggedInEmail'];
    // String currentMonthId = Get.arguments['currentMonthId'];

    controller.spentNameC.text = record.spentName!;
    controller.spentTypeC.value = record.spentType!;
    controller.priceC.text = record.total.toString();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('EditSpendingView'),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed(Routes.HOME),
        ),
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
            Obx(
              () => controller.isImageChanged.isFalse
                  ? record.attachment == ""
                      ? SizedBox()
                      : Align(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Image.network(record.attachment!),
                          ),
                        )
                  : Align(
                      alignment: Alignment.center,
                      child: GetBuilder<EditSpendingController>(
                        builder: (c) => c.pickedImage != null
                            ? Column(
                                children: [
                                  Container(
                                    height: 200,
                                    width: 200,
                                    child: Image(
                                      image:
                                          FileImage(File(c.pickedImage!.path)),
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
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => controller.updateSpending(Get.parameters),
              child: Text('Update'),
            )
          ],
        ),
      ),
    );
  }
}
