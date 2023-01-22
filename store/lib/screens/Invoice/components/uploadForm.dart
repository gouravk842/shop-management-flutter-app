import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:store/components/alertBox.dart';
import 'package:store/components/button.dart';
import 'package:store/components/currentDate.dart';
import 'package:store/components/dropdown.dart';
import 'package:store/components/textInputField.dart';

class UploadInvoice extends StatefulWidget {
  @override
  _UploadInvoiceState createState() => _UploadInvoiceState();
}

var companyList, productList, firestoreInstance = FirebaseFirestore.instance;
SingleValueDropDownController companyController =
    SingleValueDropDownController();
SingleValueDropDownController productController =
    SingleValueDropDownController();

TextEditingController amountPaidController = TextEditingController();

SingleValueDropDownController paymentModeController =
    SingleValueDropDownController();

generateCompanyList() async {
  companyList = await firestoreInstance.collection('company').get();

  companyList = companyList.docs
      .map((doc) => {'value': doc.id, 'name': doc.data()['name']})
      .toList();
  return companyList;
}

List paymentModeList = [
  {'value': 'upi', 'name': "UPI"},
  {'value': 'cash', 'name': "Cash"},
  {'value': 'bank', 'name': "Bank"},
  {'value': 'cheque', 'name': "Cheque"},
];
generateProductList() async {
  productList = await firestoreInstance
      .collection('masterProductList')
      // .where('company_name', isEqualTo: companyController.dropDownValue?.name)
      .get();
  productList = productList.docs
      .map((doc) => {'value': doc.id, 'name': doc.data()['name']})
      .toList();

  return productList;
}

final quantityController = TextEditingController();
final invoiceController = TextEditingController();
final priceController = TextEditingController();
final taxController = TextEditingController();
var selectedProductList = [];
double totalAmount = 0.0;

bool isProductEmpty = false;
bool isQuantityEmpty = false;
bool isPriceEmpty = false;

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
  ]);
  tableRow.add(header);
  selectedProductList.forEach((element) {
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
    ]);
    tableRow.add(tablerow);
  });
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

saveInvoice(context) {
  firestoreInstance.collection('invoice').add({
    'invoice_no': invoiceController.text,
    'invoice_type': "seller",
    'product': selectedProductList,
    'company_name': companyController.dropDownValue?.name,
    'company_id': companyController.dropDownValue?.value,
    'tax': double.parse(
        taxController.text.isNotEmpty ? taxController.text : '0.0'),
    'totalPaid': double.parse(amountPaidController.text),
    'amount': totalAmount,
    'total_amount': totalAmount +
        double.parse((taxController.text.isEmpty) ? '0.0' : taxController.text),
    'total_amount_paid': FieldValue.arrayUnion([
      {
        'amount': double.parse(amountPaidController.text),
        'created_on': currentDate(),
        'timestamp': DateTime.now(),
        'mode': paymentModeController.dropDownValue?.value
      }
    ]),
    "createdOn": DateTime.now(),
    "bill_date": currentDate()
  }).then((value) => saveProduct(context));
}

saveProduct(context) {
  for (var element in selectedProductList) {
    var prod_details = {
      'quantity': element['quantity'],
      'tag': 'add',
      'bill_date': currentDate(),
      // 'createdOn': DateTime.now(),
      'invoice': invoiceController.text
    };
    firestoreInstance.collection('product').doc(element['id']).set({
      "data": FieldValue.arrayUnion([prod_details])
    }, SetOptions(merge: true)).then((value) => alertbox(
        context: context,
        alertType: AlertType.success,
        title: 'Success',
        description: 'Invoice Added',
        buttontitle: 'Close',
        onpressed: () {
          FocusManager.instance.primaryFocus?.unfocus();

          selectedProductList.clear();
          priceController.clear();
          quantityController.clear();
          invoiceController.clear();
          taxController.clear();
          totalAmount = 0.0;

          Navigator.pushReplacementNamed(context, 'admin');
        }));
  }
}

class _UploadInvoiceState extends State<UploadInvoice> {
  @override
  void initState() {
    isProductEmpty = false;
    isQuantityEmpty = false;
    isPriceEmpty = false;
  }

  @override
  void dispose() {
    selectedProductList.clear();
    priceController.clear();
    quantityController.clear();
    invoiceController.clear();
    taxController.clear();
    totalAmount = 0.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          const Text(
            'Invoice Entry',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          textInputField(
              hintText: '',
              labelText: 'Invoice No',
              textEditingController: invoiceController,
              isError: false,
              isPassword: false),
          const SizedBox(
            height: 10,
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
                      dropdownValueList: companyList,
                      onchanged: (val) {});
                }
              }),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Product Entry',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
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
          const SizedBox(
            height: 30,
          ),
          (selectedProductList.isNotEmpty)
              ? Table(children: createTableRow())
              : const Text(''),
          const Divider(),
          const SizedBox(
            height: 30,
          ),
          (selectedProductList.isNotEmpty)
              ? Row(
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
                )
              : Text(''),
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
              // isCustNameEmpty = false;
              // isCustMobileEmpty = false;
              // isCustAddEmpty = false;
              if (selectedProductList.isNotEmpty) {
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
                // TODO implement error for upload invoice screen
              }
            },
            child: Text("Save Invoice".toUpperCase()),
          ),
        ],
      ),
    );
  }
}
