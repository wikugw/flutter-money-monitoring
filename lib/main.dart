import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authC = Get.put(AuthController(), permanent: true);

  @override
  void initState() {
    super.initState();
    notificationManager.setOnNotkificationReceive(onNotificationReceive);
    notificationManager.setOnNotificationClick(onNotificatioinClick);
  }

  onNotificationReceive(notification) {
    print('Notification Received: ${notification.id}');
  }

  onNotificatioinClick(payload) {
    print('Payload $payload');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authC.autoLogin(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return GetMaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              debugShowCheckedModeBanner: false,
              title: "Application",
              initialRoute: Routes.HOME,
              getPages: AppPages.routes,
            );
          } else {
            return GetMaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              debugShowCheckedModeBanner: false,
              title: "Application",
              initialRoute: Routes.LOGIN,
              getPages: AppPages.routes,
            );
          }
        }
        return MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          debugShowCheckedModeBanner: false,
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}

// 