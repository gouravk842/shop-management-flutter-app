import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:store/components/alertBox.dart';
import 'package:store/components/button.dart';
import 'package:store/responsive.dart';
import 'package:store/screens/Invoice/InvoicePdf.dart';
import 'package:store/screens/ReportGeneration/CustomerAccountReport.dart';
import 'package:store/screens/ReportGeneration/component/Report_Generation_screen_top_image.dart';
import 'package:store/screens/ReportGeneration/productWiseReportScreen.dart';

import '../../components/background.dart';
import 'TodaySellingReportScreen.dart';

class ReportGenerationScreen extends StatelessWidget {
  const ReportGenerationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.center,
      screenTitle: 'Login Panel',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileReportPanelScreen(),
          desktop: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}

List invoiceTypeList = [
  {'value': 'seller', 'name': "seller"},
  {'value': 'customer', 'name': "customer"},
];
SingleValueDropDownController invoiceTypeController =
    SingleValueDropDownController();

TextEditingController invoiceNoController = TextEditingController();

class MobileReportPanelScreen extends StatelessWidget {
  MobileReportPanelScreen({
    Key? key,
  }) : super(key: key);

  CollectionReference invoice =
      FirebaseFirestore.instance.collection('invoice');

  searchInvoice() async {
    QuerySnapshot details = await invoice
        .where('invoice_no', isEqualTo: invoiceNoController.text)
        .get();

    return details.docs.isNotEmpty;
  }

  @override
  void initState() {
    invoiceNoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const ReportScreenTopImage(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ProductWiseReportGenerationScreen();
                      },
                    ),
                  );
                },
                child: const Text("Product Wise Report"),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: const Text('Invoice Search'),
                            content: Container(
                              height: 70,
                              child: Column(
                                children: [
                                  // dropdown(
                                  //     inputFieldHintText: 'Select Invoice Type',
                                  //     inputFieldLabelText: 'Invoice Type',
                                  //     controller: invoiceTypeController,
                                  //     hintText: 'Select Type',
                                  //     dropdownValueList: invoiceTypeList,
                                  //     onchanged: (val) {}),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  TextField(
                                    // keyboardType: TextInputType.number,
                                    controller: invoiceNoController,
                                    decoration: const InputDecoration(
                                        hintText: "Invoice No"),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              clickableButton('Search', () async {
                                bool val = await searchInvoice();
                                if (val) {
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PdfInvoiceScreen(
                                        invoiceNo: (invoiceNoController.text),
                                      ),
                                    ),
                                  );
                                } else {
                                  alertbox(
                                      context: context,
                                      alertType: AlertType.error,
                                      title: 'Error',
                                      description: 'Invoice Not Found',
                                      buttontitle: 'Close',
                                      onpressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        Navigator.pop(context);
                                      });
                                }
                              })
                            ]);
                      });
                },
                child: const Text("Search Invoice"),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const TodaySellingReportGenerationScreen();
                      },
                    ),
                  );
                },
                child: const Text("Today Invoice Report"),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const CustomerAccountReportGenerationScreen();
                      },
                    ),
                  );
                },
                child: const Text("Account Report"),
              ),
              const SizedBox(
                height: 5,
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return TodaySellingReportGenerationScreen();
              //         },
              //       ),
              //     );
              //   },
              //   child: const Text("Seller Account Report"),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
