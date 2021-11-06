import 'package:flutter/material.dart';

class DropDownSearchStyle {
  static List<String> typeList = [
    "Rumah tangga",
    "Makanan/Minuman",
    "Transportasi",
    "Belanja",
    "Pendidikan",
    "Kesehatan",
    "Perawatan",
    "Investasi",
    'Lain - lain'
  ];
  static InputDecoration getDropDownSearchStyle(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Color(0xFFF6F6F6),
      prefixIcon: Icon(Icons.format_list_bulleted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 0.0),
      ),
      labelText: '$label',
    );
  }
}
