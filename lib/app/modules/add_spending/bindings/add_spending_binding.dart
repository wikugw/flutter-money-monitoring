import 'package:get/get.dart';

import '../controllers/add_spending_controller.dart';

class AddSpendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSpendingController>(
      () => AddSpendingController(),
    );
  }
}
