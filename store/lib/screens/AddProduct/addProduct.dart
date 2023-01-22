import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:store/components/dropdown.dart';
import 'package:store/components/screenTitle.dart';
import 'package:store/constants.dart';
import 'package:store/responsive.dart';

import '../../components/alertBox.dart';
import '../../components/background.dart';
import '../../components/button.dart';
import '../../components/textInputField.dart';

class ProductEntry extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductEntry> {
  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.center,
      screenTitle: 'Add Product',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const ProductEntryMobileScreen(),
          desktop: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}

final productNameController = TextEditingController();
final productDescriptionController = TextEditingController();

CollectionReference company = FirebaseFirestore.instance.collection('company');
CollectionReference productRef =
    FirebaseFirestore.instance.collection('masterProductList');

SingleValueDropDownController companyController =
    SingleValueDropDownController();

saveCompany(String name, String description, context, companyName, companyId) {
  productRef.add({
    "name": name.toLowerCase(),
    "description": description,
    "createdOn": DateTime.now(),
    "company_name": companyName,
    "company_id": companyId
  }).then((value) => alertbox(
      context: context,
      alertType: AlertType.success,
      title: 'Success',
      description: 'Product Added',
      buttontitle: 'Close',
      onpressed: () {
        Navigator.pop(context);
        productNameController.clear();
        productDescriptionController.clear();
        // companyController.clearDropDown();
        FocusManager.instance.primaryFocus?.unfocus();
      }));
}

class ProductEntryMobileScreen extends StatefulWidget {
  const ProductEntryMobileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductEntryMobileScreen> createState() =>
      _ProductEntryMobileScreenState();
}

var firestoreInstance = FirebaseFirestore.instance;
var companyList, companylist = [];

generateCompanyList() async {
  companyList = await firestoreInstance.collection('company').get();

  var data = companyList.docs
      .map((doc) => {'id': doc.id, 'name': doc.data()['name']})
      .toList();

  companylist =
      data.map((doc) => {'name': doc['name'], 'value': doc['id']}).toList();

  return companylist;
}

class _ProductEntryMobileScreenState extends State<ProductEntryMobileScreen> {
  bool nameError = false, descriptionError = false;
  var companyList = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          screenTitle('Add Product', FontWeight.bold, 20, Colors.black),
          const SizedBox(
            height: 15,
          ),
          FutureBuilder(
              future: generateCompanyList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("Loading"),
                  );
                } else {
                  return dropdown(
                      inputFieldHintText: 'Select Company',
                      inputFieldLabelText: 'Company',
                      controller: companyController,
                      hintText: 'Select Company',
                      dropdownValueList: companylist,
                      onchanged: (val) {});
                }
              }),
          const SizedBox(
            height: 15,
          ),
          textInputField(
              hintText: '',
              labelText: 'Product Name',
              textEditingController: productNameController,
              isError: nameError,
              isPassword: false),
          const SizedBox(
            height: 15,
          ),
          textInputField(
              hintText: '',
              labelText: 'Product Description',
              textEditingController: productDescriptionController,
              isError: descriptionError,
              isPassword: false),
          const SizedBox(height: defaultPadding),
          clickableButton('Save', () {
            if (productNameController.text.isNotEmpty &&
                productDescriptionController.text.isNotEmpty) {
              nameError = false;
              descriptionError = false;
              saveCompany(
                  productNameController.text,
                  productDescriptionController.text,
                  context,
                  companyController.dropDownValue?.name,
                  companyController.dropDownValue?.value);
            } else {
              if (productNameController.text.isEmpty) {
                nameError = true;
              }
              if (productDescriptionController.text.isEmpty) {
                descriptionError = true;
              }
            }
            setState(() {});
          })
        ],
      ),
    );
  }
}
