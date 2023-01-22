import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

dropdown(
    {required controller,
    required String hintText,
    required String inputFieldLabelText,
    required String inputFieldHintText,
    required List dropdownValueList,
    required Function(dynamic) onchanged}) {
  List<DropDownValueModel> dropdownValue = [];
  for (var value in dropdownValueList) {
    dropdownValue.add(
      DropDownValueModel(name: value['name'], value: value['value']),
    );
  }
  return DropDownTextField(
    // initialValue: "name4",
    controller: controller,
    clearOption: true,
    enableSearch: true,
    clearIconProperty: IconProperty(color: Colors.green),
    searchDecoration: InputDecoration(hintText: hintText),
    textFieldDecoration: InputDecoration(
        labelText: inputFieldLabelText, hintText: inputFieldHintText),
    validator: (value) {
      if (value == null) {
        return "Required field";
      } else {
        return null;
      }
    },
    dropDownItemCount: 5,

    dropDownList: dropdownValue,
    onChanged: onchanged,
  );
}
