import 'package:get/get.dart';

import '../controllers/edit_spending_controller.dart';

class EditSpendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditSpendingController>(
      () => EditSpendingController(),
    );
  }
}
