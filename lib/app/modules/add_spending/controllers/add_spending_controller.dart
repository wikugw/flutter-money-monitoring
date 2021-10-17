import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSpendingController extends GetxController {
  late TextEditingController spentNameC;
  late TextEditingController priceC;
  var spentTypeC = "".obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addSpending(params) async {
    print(spentTypeC);
    print(spentNameC.text);
    print(priceC.text);
    print(params['loggedInEmail']);
    print(params['currentMonthId']);
    // final currentUser = await firestore.collection('users').doc(loggedInEmail).collection('moneyHistory').doc()
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
