import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:store/components/alertBox.dart';
import 'package:store/components/currentDate.dart';
import 'package:store/components/dropdown.dart';
import 'package:store/components/screenTitle.dart';
import 'package:store/components/textInputField.dart';
import 'package:store/screens/Invoice/InvoicePdf.dart';

import '../../../components/button.dart';

class SellingInvoiceForm extends StatefulWidget {
  const SellingInvoiceForm({super.key});

  @override
  _SellingInvoiceState createState() => _SellingInvoiceState();
}

TextEditingController customerNameController = TextEditingController();

TextEditingController addressController = TextEditingController();
TextEditingController mobileController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController amountPaidController = TextEditingController();

SingleValueDropDownController productController =
    SingleValueDropDownController();

SingleValueDropDownController paymentModeController =
    SingleValueDropDownController();
TextEditingController taxController = TextEditingController();
List<Map> selectedProductList = [];
var productList;

double totalAmount = 0.0;

bool isProductEmpty = false;
bool isQuantityEmpty = false;
bool isPriceEmpty = false;
bool isCustNameEmpty = false;
bool isCustMobileEmpty = false;
bool isCustAddEmpty = false;
var firestoreInstance = FirebaseFirestore.instance;
createTableRow() {
  List<TableRow> tableRow = [];
  var header = const TableRow(children: [
    Text(
      'Product',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Quantity',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Rate',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Amount',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      '',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  ]);
  tableRow.add(header);
  for (var element in selectedProductList) {
    var tablerow = TableRow(children: [
      Text(
        element['name'],
        style: const TextStyle(fontSize: 15.0),
        textAlign: TextAlign.center,
      ),
      Text(
        element['quantity'].toString(),
        style: const TextStyle(fontSize: 15.0),
        textAlign: TextAlign.center,
      ),
      Text(
        element['rate'].toString(),
        style: const TextStyle(fontSize: 15.0),
        textAlign: TextAlign.center,
      ),
      Text(
        element['amount'].toString(),
        style: const TextStyle(fontSize: 15.0),
        textAlign: TextAlign.center,
      ),
      IconButton(
          splashRadius: 2,
          padding: EdgeInsets.zero,
          alignment: Alignment.topCenter,
          icon: const Icon(Icons.delete),
          iconSize: 24.0,
          color: Colors.red.shade400,
          onPressed: () {}),
    ]);
    tableRow.add(tablerow);
  }
  return tableRow;
}

calculatePrice() {
  Map product = {};
  double amount = (double.parse(priceController.text)) *
      (double.parse(quantityController.text));
  product['name'] = productController.dropDownValue?.name;
  product['rate'] = double.parse(priceController.text);
  product['quantity'] = double.parse(quantityController.text);
  product['amount'] = amount;

  product['id'] = productController.dropDownValue?.value;

  selectedProductList.add(product);

  totalAmount += amount;
}

List paymentModeList = [
  {'value': 'upi', 'name': "UPI"},
  {'value': 'cash', 'name': "Cash"},
  {'value': 'bank', 'name': "Bank"},
  {'value': 'cheque', 'name': "Cheque"},
];

generateProductList() async {
  productList = await firestoreInstance.collection('masterProductList').get();
  productList = productList.docs
      .map((doc) => {'value': doc.id, 'name': doc.data()['name']})
      .toList();

  return productList;
}

CollectionReference shop = firestoreInstance.collection('shopDetails');
int invoice_no = 0;
getInvoiceNo() async {
  DocumentSnapshot<Object?> details = await shop.doc('details').get();
  invoice_no = details.get('last_invoice');
}

updateInvoiceNo() async {
  await shop
      .doc('details')
      .set({'last_invoice': invoice_no + 1}, SetOptions(merge: true));
}

saveInvoice(context) async {
  await getInvoiceNo();

  firestoreInstance.collection('invoice').add({
    'invoice_no': (invoice_no + 1).toString(),
    "invoice_type": "customer",
    'product': selectedProductList,
    'customer_name': customerNameController.text,
    'address': addressController.text,
    'mobile': mobileController.text,
    'totalPaid': double.parse(amountPaidController.text),
    'amount': totalAmount,
    'total_amount_paid': FieldValue.arrayUnion([
      {
        'amount': double.parse(amountPaidController.text),
        'created_on': currentDate(),
        'mode': paymentModeController.dropDownValue?.value
      }
    ]),
    'tax':
        double.parse(taxController.text.isNotEmpty ? taxController.text : '0'),
    'total_amount': totalAmount +
        double.parse((taxController.text.isEmpty) ? '0.0' : taxController.text),
    'bill_date': currentDate(),
    'created_on': DateTime.now()
  }).then((value) => saveProduct(context));
}

saveProduct(context) {
  updateInvoiceNo();
  for (var element in selectedProductList) {
    var prodDetails = {
      'quantity': element['quantity'],
      'tag': 'sub',
      'createOn': currentDate(),
      'invoice': (invoice_no + 1).toString()
    };
    firestoreInstance.collection('product').doc(element['id']).set({
      "data": FieldValue.arrayUnion([prodDetails])
    }, SetOptions(merge: true)).then((value) => alertbox(
        context: context,
        alertType: AlertType.success,
        title: 'Success',
        description: 'Invoice Added',
        buttontitle: 'Close',
        onpressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          selectedProductList.clear();
          customerNameController.clear();
          addressController.clear();
          mobileController.clear();
          priceController.clear();
          quantityController.clear();
          taxController.clear();
          totalAmount = 0.0;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfInvoiceScreen(
                invoiceNo: (invoice_no + 1).toString(),
              ),
            ),
          );
          // Navigator.pushReplacementNamed(context, 'admin');
        }));
  }
}

class _SellingInvoiceState extends State<SellingInvoiceForm> {
  @override
  void dispose() {
    productList.clear();
    totalAmount = 0.0;
    customerNameController.clear();
    quantityController.clear();

    addressController.clear();
    taxController.clear();
    mobileController.clear();
    priceController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(children: [
          screenTitle('Selling Invoice', FontWeight.bold, 20, Colors.black),
          const SizedBox(
            height: 10,
          ),
          textInputField(
              hintText: '',
              labelText: 'Customer Name',
              textEditingController: customerNameController,
              isError: isCustNameEmpty,
              isPassword: false),
          const SizedBox(
            height: 10,
          ),
          textInputField(
              hintText: '',
              labelText: 'Address',
              textEditingController: addressController,
              isError: isCustAddEmpty,
              isPassword: false),
          const SizedBox(
            height: 10,
          ),
          textInputField(
              hintText: '',
              labelText: 'Mobile',
              textEditingController: mobileController,
              isError: isCustMobileEmpty,
              isPassword: false),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          screenTitle('Add Product', FontWeight.bold, 15, Colors.black),
          const SizedBox(
            height: 10,
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
            height: 10,
          ),
          textInputField(
              hintText: '',
              labelText: 'Quantity',
              textEditingController: quantityController,
              isError: isQuantityEmpty,
              isPassword: false),
          const SizedBox(
            height: 10,
          ),
          textInputField(
              hintText: '',
              labelText: 'Price',
              textEditingController: priceController,
              isError: isPriceEmpty,
              isPassword: false),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              if (priceController.text.isNotEmpty &&
                  quantityController.text.isNotEmpty &&
                  productController.dropDownValue != null) {
                calculatePrice();

                isPriceEmpty = false;
                isProductEmpty = false;
                isQuantityEmpty = false;

                setState(() {
                  quantityController.clear();
                  priceController.clear();
                });
              } else {
                if (priceController.text.isEmpty) {
                  isPriceEmpty = true;
                } else {
                  isPriceEmpty = false;
                }

                if (quantityController.text.isEmpty) {
                  isQuantityEmpty = true;
                } else {
                  isQuantityEmpty = false;
                }

                setState(() {});
              }
            },
            child: Text("Add Product".toUpperCase()),
          ),
          const Divider(),
          (selectedProductList.isNotEmpty)
              ? Table(children: createTableRow())
              : const Text(''),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 20,
              ),
              Text('Rs. $totalAmount'),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          textInputField(
              hintText: '',
              labelText: 'Tax Amount',
              textEditingController: taxController,
              isError: false,
              isPassword: false),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              isCustNameEmpty = false;
              isCustMobileEmpty = false;
              isCustAddEmpty = false;
              if (customerNameController.text.isNotEmpty &&
                  mobileController.text.isNotEmpty &&
                  addressController.text.isNotEmpty &&
                  selectedProductList.isNotEmpty) {
                showDialog(
                    context: context,
                    builder: (context) {
                      paymentModeController.clearDropDown();
                      amountPaidController.clear();
                      return AlertDialog(
                          title: const Text('Payment Info '),
                          content: Container(
                            height: 150,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Total Amount To Be Paid '),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text((totalAmount +
                                            double.parse(
                                                taxController.text.isNotEmpty
                                                    ? taxController.text
                                                    : '0'))
                                        .toString())
                                  ],
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: amountPaidController,
                                  decoration: const InputDecoration(
                                      hintText: "Amount Paid"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                dropdown(
                                    inputFieldHintText: 'Select Payment Mode',
                                    inputFieldLabelText: 'Payment',
                                    controller: paymentModeController,
                                    hintText: 'Select Mode',
                                    dropdownValueList: paymentModeList,
                                    onchanged: (val) {})
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            clickableButton('Save', () {
                              String paymentMode = paymentModeController
                                          .dropDownValue?.value ==
                                      Null
                                  ? paymentModeController.dropDownValue?.value
                                  : "";

                              if (paymentMode == '' &&
                                  amountPaidController.text.isEmpty) {
                                alertbox(
                                    context: context,
                                    alertType: AlertType.error,
                                    title: 'Error',
                                    description: 'Please Provide Input',
                                    buttontitle: 'Close',
                                    onpressed: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      Navigator.pop(context);
                                    });
                              } else {
                                saveInvoice(context);
                              }
                            }),
                          ]);
                    });
              } else {
                if (customerNameController.text.isEmpty) {
                  isCustNameEmpty = true;
                }
                if (mobileController.text.isEmpty) {
                  isCustMobileEmpty = true;
                }
                if (addressController.text.isEmpty) {
                  isCustAddEmpty = true;
                }
              }
              setState(() {});
            },
            child: Text("Save Invoice".toUpperCase()),
          ),
        ]));
  }
}
