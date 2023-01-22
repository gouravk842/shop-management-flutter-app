import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:store/components/detailsCard.dart';
import 'package:store/components/screenTitle.dart';
import 'package:store/constants.dart';
import 'package:store/responsive.dart';

import '../../components/alertBox.dart';
import '../../components/background.dart';
import '../../components/button.dart';
import '../../components/textInputField.dart';

class CompanyEntry extends StatefulWidget {
  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<CompanyEntry> {
  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.center,
      screenTitle: 'Add Company',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const CompanyEntryMobileScreen(),
          desktop: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}

final companyNameController = TextEditingController();
final companyDescriptionController = TextEditingController();

CollectionReference company = FirebaseFirestore.instance.collection('company');

saveCompany(String name, String description, context) {
  company.add({
    "name": name.toLowerCase(),
    "description": description,
    "createdOn": DateTime.now()
  }).then((value) => alertbox(
      context: context,
      alertType: AlertType.success,
      title: 'Success',
      description: 'Company Added',
      buttontitle: 'Close',
      onpressed: () {
        Navigator.pop(context);
        companyNameController.clear();
        companyDescriptionController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
      }));
}

class CompanyEntryMobileScreen extends StatefulWidget {
  const CompanyEntryMobileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CompanyEntryMobileScreen> createState() =>
      _CompanyEntryMobileScreenState();
}

class _CompanyEntryMobileScreenState extends State<CompanyEntryMobileScreen> {
  bool nameError = false, descriptionError = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('company').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (querySnapshot.hasError) {
            return const Text('some error');
          } else if (querySnapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading....');
          } else {
            final l = querySnapshot.data!.docs;

            return (l.isEmpty)
                ? const Text('No Document Found')
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: l.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return details_card(
                          l[index].get('name'), l[index].get('description'));
                    });
          }
        });

    // Padding(
    //   padding: const EdgeInsets.all(20.0),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       screenTitle('Add Company', FontWeight.bold, 20, Colors.black),
    //       const SizedBox(
    //         height: 15,
    //       ),
    //       textInputField(
    //           hintText: '',
    //           labelText: 'Company Name',
    //           textEditingController: companyNameController,
    //           isError: nameError,
    //           isPassword: false),
    //       const SizedBox(
    //         height: 15,
    //       ),
    //       textInputField(
    //           hintText: '',
    //           labelText: 'Company Description',
    //           textEditingController: companyDescriptionController,
    //           isError: descriptionError,
    //           isPassword: false),
    //       const SizedBox(height: defaultPadding),
    //       clickableButton('Save', () {
    //         if (companyNameController.text.isNotEmpty &&
    //             companyDescriptionController.text.isNotEmpty) {
    //           nameError = false;
    //           descriptionError = false;
    //           saveCompany(companyNameController.text,
    //               companyDescriptionController.text, context);
    //         } else {
    //           if (companyNameController.text.isEmpty) {
    //             nameError = true;
    //           }
    //           if (companyDescriptionController.text.isEmpty) {
    //             descriptionError = true;
    //           }
    //         }
    //         setState(() {});
    //       })
    //     ],
    //   ),
    // );
  }
}
