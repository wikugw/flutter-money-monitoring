import 'package:get/get.dart';

import 'package:money_monitoring/app/modules/add_spending/bindings/add_spending_binding.dart';
import 'package:money_monitoring/app/modules/add_spending/views/add_spending_view.dart';
import 'package:money_monitoring/app/modules/edit_spending/bindings/edit_spending_binding.dart';
import 'package:money_monitoring/app/modules/edit_spending/views/edit_spending_view.dart';
import 'package:money_monitoring/app/modules/home/bindings/home_binding.dart';
import 'package:money_monitoring/app/modules/home/views/home_view.dart';
import 'package:money_monitoring/app/modules/login/bindings/login_binding.dart';
import 'package:money_monitoring/app/modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SPENDING,
      page: () => AddSpendingView(),
      binding: AddSpendingBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_SPENDING,
      page: () => EditSpendingView(),
      binding: EditSpendingBinding(),
    ),
  ];
}
