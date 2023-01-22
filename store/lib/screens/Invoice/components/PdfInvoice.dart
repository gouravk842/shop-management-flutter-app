import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import 'package:store/components/button.dart';
import 'package:store/components/currentDate.dart';
import 'package:store/components/dropdown.dart';

import 'invoice.dart';

class PdfInvoiceForm extends StatefulWidget {
  final String invoiceId;
  PdfInvoiceForm({Key? key, required this.invoiceId}) : super(key: key);

  @override
  State<PdfInvoiceForm> createState() => _PdfInvoiceFormState();
}

class _PdfInvoiceFormState extends State<PdfInvoiceForm> {
  CollectionReference shop =
      FirebaseFirestore.instance.collection('shopDetails');

  CollectionReference invoice =
      FirebaseFirestore.instance.collection('invoice');

  String sellerName = '';

  String sellerAddress = '';

  String sellerMobile = '';

  List productList = [];

  List paymentList = [];

  String custName = '';

  String custAdd = '';

  String custMobile = '';

  String invoiceNo = '';

  String invoiceDate = '';

  String soldBy = '';

  double totalAmount = 0.0;

  double totalAmountInclusiveTax = 0.0;

  double totalPaid = 0.0;

  double amountLeft = 0.0;

  double tax = 0.0;

  String invoiceId = '';

  String invoiceType = '';

  late SingleValueDropDownController paymentModeController =
      SingleValueDropDownController();

  TextEditingController amountPaidController = TextEditingController();
  List paymentModeList = [
    {'value': 'upi', 'name': "UPI"},
    {'value': 'cash', 'name': "Cash"},
    {'value': 'bank', 'name': "Bank"},
    {'value': 'cheque', 'name': "Cheque"},
  ];

  retrieveShopDetails() async {
    DocumentSnapshot<Object?> details = await shop.doc('details').get();

    sellerName = details.get('name');
    sellerMobile = details.get('mobile');
    sellerAddress = details.get('address');
  }

  savePayment(context) async {
    FirebaseFirestore.instance.collection('invoice').doc(invoiceId).set({
      "totalPaid": totalPaid + double.parse(amountPaidController.text),
      "total_amount_paid": FieldValue.arrayUnion([
        {
          'amount': double.parse(amountPaidController.text),
          'created_on': currentDate(),
          'mode': paymentModeController.dropDownValue?.value,
          'timestamp': DateTime.now()
        }
      ])
    }, SetOptions(merge: true)).then((value) => refreshScreen(context));
  }

  refreshScreen(context) {
    amountPaidController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context);
    setState(() {});
  }

  addPaymentPopUp(context) {
    showDialog(
        context: context,
        builder: (context) {
          paymentModeController.clearDropDown();
          // amountPaidController.clear();
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
                        Text(amountLeft.toString())
                      ],
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: amountPaidController,
                      decoration: const InputDecoration(hintText: "Amount "),
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
                  String paymentMode =
                      paymentModeController.dropDownValue?.value != Null
                          ? paymentModeController.dropDownValue?.value
                          : "";

                  if (paymentMode != '' &&
                      amountPaidController.text.isNotEmpty) {
                    savePayment(context);
                  }
                }),
              ]);
        });
  }

  retrieveInvoiceDetails() async {
    QuerySnapshot details =
        await invoice.where('invoice_no', isEqualTo: widget.invoiceId).get();

    if (details.docs.isNotEmpty) {
      invoiceType = details.docs[0].get('invoice_type');
      invoiceId = details.docs[0].id;
      productList = details.docs[0].get('product');
      try {
        custAdd = details.docs[0].get('address');
      } catch (e) {
        custAdd = '';
      }
      try {
        custName = details.docs[0].get('customer_name');
      } catch (e) {}

      try {
        custMobile = details.docs[0].get('mobile');
      } catch (e) {}

      try {
        paymentList = details.docs[0].get('total_amount_paid');
      } catch (e) {
        paymentList = [];
      }

      invoiceNo = details.docs[0].get('invoice_no');
      invoiceDate = details.docs[0].get('bill_date');
      tax = details.docs[0].get('tax');
      try {
        totalAmountInclusiveTax = details.docs[0].get('total_amount') * 1.0;
      } catch (e) {
        totalAmountInclusiveTax = 0.0;
      }

      totalAmount = details.docs[0].get('amount') * 1.0;
      totalPaid = details.docs[0].get('totalPaid') * 1.0;
      amountLeft = totalAmountInclusiveTax - totalPaid;
    }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    createTableRow(productDetails) {
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
      productDetails.forEach((element) {
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

    createPaymentTableRow(paymentDetails) {
      List<TableRow> tableRow = [];
      var header = const TableRow(children: [
        Text(
          'Date',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          'Amount',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          'Mode',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ]);
      tableRow.add(header);
      paymentDetails.forEach((element) {
        var tablerow = TableRow(children: [
          Text(
            element['created_on'],
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            element['amount'].toString(),
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            element['mode'],
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
        ]);
        tableRow.add(tablerow);
      });
      return tableRow;
    }

    createCompanyDetails() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (invoiceType == 'seller') ? 'Billed To' : 'Seller Name',
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  sellerName,
                  textAlign: TextAlign.start,
                ),
                Text(
                  sellerAddress,
                  textAlign: TextAlign.start,
                ),
                Text(
                  sellerMobile,
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          SizedBox(
            width: screenWidth / 4,
          ),
          (invoiceType == 'customer')
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Billed To',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        custName,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        custAdd,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        custMobile,
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                )
              : const Text('')
        ],
      );
    }

    createButton() {
      return Row(
        children: [
          (amountLeft != 0)
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                    child: clickableButton('Add Payment', () {
                      addPaymentPopUp(context);
                    }),
                  ),
                )
              : const SizedBox(
                  width: 0,
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
              child: clickableButton('Share', () async {
                Share.shareXFiles([
                  XFile.fromData(
                    await generateInvoice(
                        productList,
                        invoiceNo,
                        invoiceDate,
                        (invoiceType == 'seller') ? sellerName : custName,
                        (invoiceType == 'seller') ? sellerAddress : custAdd,
                        (invoiceType == 'seller') ? sellerMobile : custMobile,
                        totalPaid,
                        isPrint: false),
                    name: 'invoice.pdf',
                    mimeType: 'application/pdf',
                  ),
                ], subject: 'Invoice');
              }),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
              child: clickableButton('Print', () {
                generateInvoice(
                    productList,
                    invoiceNo,
                    invoiceDate,
                    (invoiceType == 'seller') ? sellerName : custName,
                    (invoiceType == 'seller') ? sellerAddress : custAdd,
                    (invoiceType == 'seller') ? sellerMobile : custMobile,
                    totalPaid);
              }),
            ),
          ),
        ],
      );
    }

    createInvoiceDetails() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Invoice No ',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                Text(invoiceNo)
              ],
            ),
          ),
          SizedBox(
            width: screenWidth / 10,
          ),
          SizedBox(
            width: screenWidth / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bill Date ',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                Text(invoiceDate)
              ],
            ),
          ),
          SizedBox(width: screenWidth / 10),
          SizedBox(
            width: screenWidth / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sell By ',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                Text(soldBy)
              ],
            ),
          )
        ],
      );
    }

    createPricingSection() {
      // setState(() {});
      return Row(
        children: [
          SvgPicture.asset(
            width: screenWidth / 5,
            height: screenHeight / 9,
            (amountLeft == 0.0)
                ? "assets/icons/right.svg"
                : "assets/icons/cross.svg",
          ),
          SizedBox(
            width: screenWidth / 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Amount',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(totalAmount.toString()),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Tax ',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(tax.toString()),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Total Amount',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(totalAmountInclusiveTax.toString()),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Amount Paid',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(totalPaid.toString()),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Amount Left ',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 20,
                  ),
                  Text((totalAmountInclusiveTax - totalPaid).toString()),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        FutureBuilder(
            future: retrieveInvoiceDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading"),
                );
              } else {
                return Text(
                  ("$invoiceType Invoice").toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                );
              }
            }),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: screenHeight * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: retrieveInvoiceDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading"),
                        );
                      } else {
                        return createInvoiceDetails();
                      }
                    }),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: retrieveShopDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading"),
                        );
                      } else {
                        return createCompanyDetails();
                      }
                    }),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: retrieveInvoiceDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading"),
                        );
                      } else {
                        return Container(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  "Product Details".toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                (productList.isNotEmpty)
                                    ? Table(
                                        border: TableBorder.all(
                                            color: Colors.green, width: 1.5),
                                        children: createTableRow(productList))
                                    : const Text(''),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
                FutureBuilder(
                    future: retrieveInvoiceDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading"),
                        );
                      } else {
                        return createPricingSection();
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: retrieveInvoiceDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text("Loading"),
                      );
                    } else {
                      return Container(
                        height: 150,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                "Payment Details".toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Divider(),
                              (productList.isNotEmpty)
                                  ? Table(
                                      border: TableBorder.all(
                                          color: Colors.green, width: 1.5),
                                      children:
                                          createPaymentTableRow(paymentList))
                                  : const Text(''),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        FutureBuilder(
            future: retrieveInvoiceDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading"),
                );
              } else {
                return createButton();
              }
            }),
      ]),
    );
  }
}
