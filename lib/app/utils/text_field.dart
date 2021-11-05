import 'package:flutter/material.dart';

class TextFieldStyle {
  static InputDecoration getTextFieldStyle(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Color(0xFFF6F6F6),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 0.0),
      ),
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      labelText: '$label',
    );
  }
}
