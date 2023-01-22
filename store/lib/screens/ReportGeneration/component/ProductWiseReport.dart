import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/components/dropdown.dart';
import 'package:store/components/screenTitle.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:store/screens/Invoice/InvoicePdf.dart';

import '../../../components/cardView.dart';

class ProductWiseReport extends StatefulWidget {
  const ProductWiseReport({super.key});

  @override
  _ProductWiseReportMobileScreenState createState() =>
      _ProductWiseReportMobileScreenState();
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
  productDetailsList.forEach((element) {
    list.add((element['tag'] == 'add')
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
            child: cardview(50.0, element['createOn'].toString(), 'gourav',
                element['invoice'], element['quantity'].toString(),
                isAdd: false)));
  });
  return list;
}

generateProductList() async {
  productList = await firestoreInstance.collection('masterProductList').get();
  productList = productList.docs
      .map((doc) => {'value': doc.id, 'name': doc.data()['name']})
      .toList();

  return productList;
}

retrieveProductDetails(String productId) async {
  productRefList =
      await firestoreInstance.collection('product').doc(productId).get();

  productDetailsList.clear();

  if (productRefList.data() != null) {
    productDetailsList = productRefList.data()['data'];
  }
  totalPurchase = 0.0;
  totalSelling = 0.0;
  // tableHeight += productDetailsList.length;
  productDetailsList.forEach(
    (element) {
      if (element['tag'] == 'add') {
        totalPurchase += element['quantity'];
      } else {
        totalSelling += element['quantity'];
      }
    },
  );
  return productDetailsList;
}

class _ProductWiseReportMobileScreenState extends State<ProductWiseReport> {
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
        screenTitle('Product Report', FontWeight.bold, 20, Colors.black),
        const SizedBox(
          height: 20,
        ),
        FutureBuilder(
            future: generateProductList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading"),
                );
              } else {
                return dropdown(
                    inputFieldHintText: 'Select Product',
                    inputFieldLabelText: 'Product',
                    controller: productController,
                    hintText: 'Select Product',
                    dropdownValueList: productList,
                    onchanged: (val) {});
              }
            }),
        const SizedBox(
          height: 20,
        ),
        const Divider(),
        ElevatedButton(
          onPressed: () {
            if (productController.dropDownValue != null) {
              productId = productController.dropDownValue?.value;
            }
            setState(() {});
          },
          child: const Text("See Report"),
        ),
        const Divider(),
        const SizedBox(
          height: 20,
        ),
        (productId != '')
            ? FutureBuilder(
                future: retrieveProductDetails(productId),
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
                })
            : const Text(''),
        const Divider(),
        (productId != '')
            ? FutureBuilder(
                future: retrieveProductDetails(productId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Purchase',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(totalPurchase.toString()),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Selling',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(totalSelling.toString()),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Quantity Left',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text((totalPurchase - totalSelling).toString()),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                })
            : const Text(''),
      ],
    );
  }
}
