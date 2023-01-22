import 'package:flutter/material.dart';

screenTitle(String title, FontWeight fontWeight, double fontSize, Color color) {
  return Text(
    title,
    style: TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
  );
}
