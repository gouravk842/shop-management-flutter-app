import 'package:flutter/material.dart';

clickableButton(String buttonLabel, Function() onPress) {
  return Hero(
    tag: buttonLabel,
    child: ElevatedButton(
      onPressed: onPress,
      child: Text(
        buttonLabel.toUpperCase(),
      ),
    ),
  );
}
