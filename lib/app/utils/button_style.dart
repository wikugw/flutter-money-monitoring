import 'package:flutter/material.dart';

class buttonStyle {
  static ButtonStyle getButtonStyle() {
    return ElevatedButton.styleFrom(
      primary: Color(0xff0071FF),
      padding: EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }
}
