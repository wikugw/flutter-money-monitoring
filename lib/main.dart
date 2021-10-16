import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authC.autoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return GetMaterialApp(
              title: "Application",
              initialRoute: Routes.HOME,
              getPages: AppPages.routes,
            );
          } else {
            GetMaterialApp(
              title: "Application",
              initialRoute: Routes.LOGIN,
              getPages: AppPages.routes,
            );
          }
        }
        return GetMaterialApp(
          title: "Application",
          initialRoute: Routes.LOGIN,
          getPages: AppPages.routes,
        );
      },
    );
  }
}

// 