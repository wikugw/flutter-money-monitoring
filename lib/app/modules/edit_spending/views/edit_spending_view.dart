import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';
import 'package:money_monitoring/app/routes/app_pages.dart';
import 'package:money_monitoring/app/utils/drop_down_style.dart';
import 'package:money_monitoring/app/utils/number_format.dart';
import 'package:money_monitoring/app/utils/text_field.dart';
import 'package:money_monitoring/app/utils/button_style.dart';

import '../controllers/edit_spending_controller.dart';

class EditSpendingView extends GetView<EditSpendingController> {
  @override
  Widget build(BuildContext context) {
    Records record = Get.arguments['record'];

    controller.spentNameC.text = record.spentName!;
    controller.spentTypeC.value = record.spentType!;
    controller.priceC.text = MoneyFormat.formatNumber(record.total.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Rubah Pengeluaran',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        centerTitle: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Get.offAllNamed(Routes.HOME),
        ),
        leadingWidth: 25,
        elevation: 0,
        backgroundColor: Colors.white,
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
                  items: DropDownSearchStyle.typeList,
                  dropdownSearchDecoration:
                      DropDownSearchStyle.getDropDownSearchStyle(
                    'Jenis pengeluaran',
                  ),
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.spentTypeC.value = value;
                    }
                  },
                  selectedItem: controller.spentTypeC.value,
                ),
                SizedBox(height: 15),
                TextField(
                  onChanged: (string) {
                    if (string != "") {
                      string =
                          '${MoneyFormat.formatNumber(string.replaceAll(',', ''))}';
                      controller.priceC.value = TextEditingValue(
                        text: string,
                        selection:
                            TextSelection.collapsed(offset: string.length),
                      );
                    }
                  },
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
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Lampiran (Opsional)',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: Get.width,
                  height: 280,
                  child: Stack(
                    children: [
                      Obx(
                        () => controller.isImageChanged.isFalse
                            ? record.attachment == ""
                                ? Align(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
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
                                  )
                                : Align(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Container(
                                        padding: EdgeInsets.zero,
                                        height: 230,
                                        width: 230,
                                        child:
                                            Image.network(record.attachment!),
                                      ),
                                    ),
                                  )
                            : Align(
                                alignment: Alignment.center,
                                child: GetBuilder<EditSpendingController>(
                                  builder: (c) => c.pickedImage != null
                                      ? Container(
                                          height: 230,
                                          width: 230,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                child: Container(
                                                  height: 230,
                                                  width: 230,
                                                  color: Colors.amber,
                                                  child: Image(
                                                    image: FileImage(File(
                                                        c.pickedImage!.path)),
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
                                      : SizedBox(),
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.updateSpending(Get.arguments),
                          child: Text('Update'),
                          style: buttonStyle.getButtonStyle(),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.deleteRecord(Get.arguments),
                          child: Icon(Icons.delete),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(60.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
