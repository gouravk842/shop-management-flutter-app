import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:store/components/alertBox.dart';
import 'package:store/components/button.dart';
import 'package:store/components/currentDate.dart';
import 'package:store/components/screenTitle.dart';
import 'package:store/components/textInputField.dart';

class ShopDetailsForm extends StatefulWidget {
  ShopDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  State<ShopDetailsForm> createState() => _ShopDetailsFormState();
}

class _ShopDetailsFormState extends State<ShopDetailsForm> {
  final shopNameController = TextEditingController();

  final shopAddressController = TextEditingController();

  final mobileController = TextEditingController();

  final emailController = TextEditingController();
  final taxController = TextEditingController();

  bool _isShopName = false;

  bool _isAddress = false;

  bool _isMobile = false;

  CollectionReference shop =
      FirebaseFirestore.instance.collection('shopDetails');

  retrieveShopDetails() async {
    DocumentSnapshot<Object?> details = await shop.doc('details').get();
    shopNameController.text = details.get('name');
    mobileController.text = details.get('mobile');
    emailController.text = details.get('email');
    shopAddressController.text = details.get('address');

    taxController.text = details.get('tax').toString();
  }

  saveShopDetails(String name, String address, String mobile, String email,
      String tax, context) {
    shop.doc('details').set({
      "name": name,
      "address": address,
      "mobile": mobile,
      "email": email,
      "tax": double.parse('0'),
      "createdOn": currentDate()
    }, SetOptions(merge: true)).then((value) => alertbox(
        context: context,
        alertType: AlertType.success,
        title: 'Success',
        description: 'Shop Details Updated',
        buttontitle: 'Close',
        onpressed: () {
          Navigator.pop(context);
          FocusManager.instance.primaryFocus?.unfocus();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: retrieveShopDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading"),
            );
          } else {
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    screenTitle(
                        'Shop Details', FontWeight.bold, 20, Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    textInputField(
                        hintText: '',
                        labelText: 'Shop Name',
                        textEditingController: shopNameController,
                        isError: _isShopName,
                        isPassword: false),
                    const SizedBox(
                      height: 15,
                    ),
                    textInputField(
                        hintText: '',
                        labelText: 'Mobile',
                        textEditingController: mobileController,
                        isError: _isMobile,
                        isPassword: false),
                    const SizedBox(
                      height: 15,
                    ),
                    textInputField(
                        hintText: '',
                        labelText: 'Email',
                        textEditingController: emailController,
                        isError: false,
                        isPassword: false),
                    const SizedBox(
                      height: 15,
                    ),
                    // textInputField(
                    //     hintText: '',
                    //     labelText: 'Tax Percentage',
                    //     textEditingController: taxController,
                    //     isError: false,
                    //     isPassword: false),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    textInputField(
                        hintText: '',
                        labelText: 'Address',
                        textEditingController: shopAddressController,
                        isError: _isAddress,
                        isPassword: false,
                        maxLine: 3),
                    const SizedBox(
                      height: 15,
                    ),
                    clickableButton('Save', () {
                      _isAddress = false;
                      _isMobile = false;
                      _isShopName = false;
                      if (shopNameController.text.isNotEmpty &&
                          shopAddressController.text.isNotEmpty &&
                          mobileController.text.isNotEmpty &&
                          taxController.text.isNotEmpty) {
                        saveShopDetails(
                            shopNameController.text,
                            shopAddressController.text,
                            mobileController.text,
                            emailController.text,
                            taxController.text,
                            context);
                      } else {
                        if (shopNameController.text.isEmpty) {
                          _isShopName = true;
                        }
                        if (shopAddressController.text.isEmpty) {
                          _isAddress = true;
                        }
                        if (mobileController.text.isEmpty) {
                          _isMobile = true;
                        }
                      }
                      setState(() {});
                    })
                  ],
                ));
          }
        });
  }
}
