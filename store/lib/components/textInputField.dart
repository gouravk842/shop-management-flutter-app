import 'package:flutter/material.dart';

textInputField(
    {required bool isPassword,
    required String labelText,
    required String hintText,
    required bool isError,
    required TextEditingController textEditingController,
    maxLine = 1}) {
  return TextField(
    maxLines: maxLine,
    obscureText: isPassword,
    decoration: InputDecoration(
        errorText: isError ? 'Please fill details' : null,
        contentPadding: const EdgeInsets.only(left: 25, right: 20, top: 5),
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 15),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText,
        hintStyle: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)),
    controller: textEditingController,
  );
}
