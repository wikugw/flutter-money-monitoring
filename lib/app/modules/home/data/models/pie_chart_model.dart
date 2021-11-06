import 'package:flutter/material.dart';

class PieDataModel {
  final String name;
  late double percent = 0;
  late Color color;
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
        color = Colors.amber;
        break;
      case 'Makanan/Minuman':
        color = Colors.red;
        break;
      case 'Transportasi':
        color = Colors.green;
        break;
      case 'Belanja':
        color = Colors.purple;
        break;
      case 'Pendidikan':
        color = Colors.cyan;
        break;
      case 'Kesehatan':
        color = Colors.pink;
        break;
      case 'Perawatan':
        color = Colors.orange;
        break;
      case 'Investasi':
        color = Colors.indigo;
        break;
      case 'Investasi':
        color = Colors.lime;
        break;
      default:
    }
  }
}
