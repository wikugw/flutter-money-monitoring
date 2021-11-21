import 'package:flutter/material.dart';

class ReceiveNotificationModel {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotificationModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
