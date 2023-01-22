import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

alertbox(
    {required context,
    required alertType,
    required String title,
    required String description,
    required String buttontitle,
    required Function() onpressed}) {
  return Alert(
    closeFunction: () {},
    closeIcon: const Icon(null),
    context: context,
    type: alertType,
    title: title,
    desc: description,
    style: AlertStyle(
      animationType: AnimationType.shrink,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.start,
      animationDuration: const Duration(milliseconds: 200),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(
          color: Colors.blue,
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.red,
      ),
      alertAlignment: Alignment.center,
    ),
    buttons: [
      DialogButton(
        onPressed: onpressed,
        width: 120,
        child: Text(
          buttontitle,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
    ],
  ).show();
}
