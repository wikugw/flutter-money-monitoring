import 'package:flutter/material.dart';

class PieDataModel {
  final String name;
  late double percent = 0;
  late Color color = Colors.amber;
  int totalPrice = 0;

  PieDataModel({
    required this.name,
  });

  void updateTotalPrice(int incomingPrice) {
    totalPrice = totalPrice + incomingPrice;
  }

  void updatePercentage(int spendInMonth) {
    percent = (totalPrice / spendInMonth) * 100;
  }

  void setColor() {
    switch (name) {
      case 'Rumah tangga':
        color = Color(0xff5ac8fa);
        break;
      case 'Makanan/Minuman':
        color = Color(0xff4cd964);
        break;
      case 'Transportasi':
        color = Color(0xff665191);
        break;
      case 'Belanja':
        color = Color(0xffffcc00);
        break;
      case 'Pendidikan':
        color = Color(0xffff3b30);
        break;
      case 'Kesehatan':
        color = Color(0xfff95d6a);
        break;
      case 'Perawatan':
        color = Color(0xffff2d55);
        break;
      case 'Investasi':
        color = Color(0xff5856d6);
        break;
      case 'Hobi':
        color = Color(0xffff9500);
        break;
      case 'Tempat tinggal':
        color = Color(0xffAA14F0);
        break;
      case 'Lain - lain':
        color = Color(0xff007aff);
        break;
      default:
    }
  }
}
