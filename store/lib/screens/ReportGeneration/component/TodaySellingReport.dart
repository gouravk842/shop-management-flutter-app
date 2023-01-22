import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/components/currentDate.dart';
import 'package:store/components/screenTitle.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:store/screens/Invoice/InvoicePdf.dart';

import '../../../components/cardView.dart';

class TodaySellingReport extends StatefulWidget {
  const TodaySellingReport({super.key});

  @override
  _TodaySellingReportMobileScreenState createState() =>
      _TodaySellingReportMobileScreenState();
}

var productList,
    productRefList,
    firestoreInstance = FirebaseFirestore.instance,
    productDetailsList = [];

String productId = '';

double totalPurchase = 0.0, totalSelling = 0.0, tableHeight = 400.0;

late SingleValueDropDownController productController =
    SingleValueDropDownController();

populateTableRow(context) {
  List<Widget> list = [];
  for (var element in productDetailsList) {
    list.add((element['tag'])
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfInvoiceScreen(
                    invoiceNo: (element['invoice']),
                  ),
                ),
              );
            },
            child: cardview(50.0, element['bill_date'].toString(), '',
                element['invoice'], element['quantity'].toString(),
                isAdd: true))
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfInvoiceScreen(
                    invoiceNo: (element['invoice']),
                  ),
                ),
              );
            },
            child: cardview(
                50.0,
                element['createOn'].toString(),
                element['createOn'].toString(),
                element['invoice'],
                element['quantity'].toString(),
                isAdd: false,
                isDate: false,
                isName: true)));
  }
  return list;
}

retrieveTodaySellingInvoiceDetails() async {
  productRefList = await firestoreInstance
      .collection('invoice')
      .where('bill_date', isEqualTo: currentDate())
      .get();

  productDetailsList.clear();

  totalPurchase = 0.0;
  totalSelling = 0.0;

  // tableHeight += productRefList.length;
  (productRefList.docs).forEach(
    (element) {
      if (element['invoice_type'] == 'customer') {
        totalSelling += element['total_amount'];

        productDetailsList.add({
          "invoice": element['invoice_no'],
          "quantity": 'Rs. ${element['total_amount']}',
          "createOn": element['customer_name'],
          "tag": element['invoice_type'] != 'customer'
        });
      }
    },
  );
  return productDetailsList;
}

class _TodaySellingReportMobileScreenState extends State<TodaySellingReport> {
  bool nameError = false, descriptionError = false;

  @override
  void initState() {
    super.initState();
    productDetailsList.clear();
    totalPurchase = 0.0;
    totalSelling = 0.0;
  }

  @override
  void dispose() {
    productDetailsList.clear();
    totalPurchase = 0.0;
    totalSelling = 0.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        screenTitle('Today Selling Report', FontWeight.bold, 20, Colors.black),
        const Divider(),
        FutureBuilder(
            future: retrieveTodaySellingInvoiceDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading"),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          currentDate(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Total Selling',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Rs. $totalSelling',
                        ),
                      ],
                    )
                  ],
                );
              }
            }),
        const Divider(),
        FutureBuilder(
            future: retrieveTodaySellingInvoiceDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading"),
                );
              } else {
                return Container(
                  height: tableHeight,
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      children: populateTableRow(context)),
                );
              }
            }),
      ],
    );
  }
}
