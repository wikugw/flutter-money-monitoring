import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:money_monitoring/app/modules/home/data/models/receive_notification_model.dart';
import 'dart:io' show Platform;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:rxdart/rxdart.dart';

class NotificationManager {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late var initSetting;
  BehaviorSubject<ReceiveNotificationModel>
      get didReceiveLocalNotificationSubject =>
          BehaviorSubject<ReceiveNotificationModel>();

  NotificationManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializePlatform();
  }

  initializePlatform() {
    var initSettingAndroid = AndroidInitializationSettings('launch_backgorund');
    var initSettingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotificationModel receiveNotification =
              ReceiveNotificationModel(
            id: id,
            title: title!,
            body: body!,
            payload: payload!,
          );
          didReceiveLocalNotificationSubject.add(receiveNotification);
        });
    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
  }

  setOnNotkificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((value) {
      onNotificationReceive(value);
    });
  }

  setOnNotificationClick(Function onNotificatioinClick) async {
    try {
      await flutterLocalNotificationsPlugin.initialize(initSetting,
          onSelectNotification: (String? payload) async {
        onNotificatioinClick(payload);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> scheduledNotification() async {
    try {
      tz.initializeTimeZones();
      // tz.setLocalLocation(tz.getLocation(timeZoneName));
      var androidChannel = AndroidNotificationDetails(
        'Chanel ID',
        'CHANNEL_NAME',
        channelDescription: 'CHANNEL_DESCRIPTION',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        // timeoutAfter: 500,
        enableLights: true,
      );
      var platformChannel = NotificationDetails(android: androidChannel);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Test Title',
        'Test Body',
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 10)),
        platformChannel,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'New Payload',
      );
    } catch (e) {
      print(e);
    }
  }
}

NotificationManager notificationManager = NotificationManager.init();
