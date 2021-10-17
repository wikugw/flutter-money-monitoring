import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/add_spending_controller.dart';

class AddSpendingView extends GetView<AddSpendingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SizedBox(height: 5),
            TextField(
              controller: controller.priceC,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total pengeluaran'),
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
