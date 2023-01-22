import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/components/screenTitle.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class CustomerAccountReport extends StatefulWidget {
  const CustomerAccountReport({super.key});

  @override
  _CustomerAccountReportMobileScreenState createState() =>
      _CustomerAccountReportMobileScreenState();
}

var productRefList, firestoreInstance = FirebaseFirestore.instance;

Map customer_list = {};

String productId = '';
String account_type = 'customer';

double totalPaid = 0.0, totalSelling = 0.0, tableHeight = 400.0;

SingleValueDropDownController productController =
    SingleValueDropDownController();
createCustomerTableRow() {
  List<TableRow> tableRow = [];
  var header = const TableRow(children: [
    Text(
      'Name',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Mobile',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Amount',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Paid',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Left',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  ]);
  tableRow.add(header);
  customer_list.forEach((key, value) {
    var tablerow = TableRow(
        decoration: BoxDecoration(
            color: (value['left'] != 0.0) ? Colors.red.shade100 : Colors.white),
        children: [
          Text(
            value['name'],
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            value['mobile'],
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            value['amount'].toString(),
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            value['paid'].toString(),
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            value['left'].toString(),
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
        ]);
    tableRow.add(tablerow);
  });
  return tableRow;
}

createSellerTableRow() {
  List<TableRow> tableRow = [];
  var header = const TableRow(children: [
    Text(
      'Name',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Amount',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Paid',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    Text(
      'Left',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  ]);
  tableRow.add(header);
  customer_list.forEach((key, value) {
    var tablerow = TableRow(
        decoration: BoxDecoration(
            color: (value['left'] != 0.0) ? Colors.red.shade100 : Colors.white),
        children: [
          Text(
            value['name'],
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            value['amount'].toString(),
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            value['paid'].toString(),
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Text(
            value['left'].toString(),
            style: const TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
        ]);
    tableRow.add(tablerow);
  });
  return tableRow;
}

retrieveTodaySellingInvoiceDetails() async {
  productRefList = await firestoreInstance
      .collection('invoice')
      // .where('bill_date', isEqualTo: currentDate())
      .get();

  customer_list.clear();

  totalPaid = 0.0;
  totalSelling = 0.0;

  // tableHeight += productRefList.length;
  (productRefList.docs).forEach(
    (element) {
      if (element['invoice_type'] == 'customer' && account_type == 'customer') {
        totalSelling += element['total_amount'];
        totalPaid += element['totalPaid'];
        if (customer_list.containsKey(element['mobile'])) {
          customer_list[element['mobile']]['amount'] =
              customer_list[element['mobile']]['amount'] +
                  element['total_amount'];

          customer_list[element['mobile']]['paid'] =
              customer_list[element['mobile']]['paid'] + element['totalPaid'];

          customer_list[element['mobile']]['left'] =
              customer_list[element['mobile']]['left'] +
                  (element['total_amount'] - element['totalPaid']);
        } else {
          customer_list[element['mobile']] = {
            "mobile": element['mobile'],
            "name": element['customer_name'],
            "amount": element['total_amount'],
            "paid": element['totalPaid'],
            "left": element['total_amount'] - element['totalPaid']
          };
        }
      } else if (element['invoice_type'] == 'seller' &&
          account_type == 'seller') {
        totalSelling += element['total_amount'];
        totalPaid += element['totalPaid'];
        if (customer_list.containsKey(element['company_id'])) {
          customer_list[element['company_id']]['amount'] =
              customer_list[element['company_id']]['amount'] +
                  element['total_amount'];

          customer_list[element['company_id']]['paid'] =
              customer_list[element['company_id']]['paid'] +
                  element['totalPaid'];

          customer_list[element['company_id']]['left'] =
              customer_list[element['company_id']]['left'] +
                  (element['total_amount'] - element['totalPaid']);
        } else {
          customer_list[element['company_id']] = {
            "name": element['company_name'],
            "amount": element['total_amount'],
            "paid": element['totalPaid'],
            "left": element['total_amount'] - element['totalPaid']
          };
        }
      }
    },
  );

  return customer_list;
}

class _CustomerAccountReportMobileScreenState
    extends State<CustomerAccountReport> {
  bool nameError = false, descriptionError = false;

  @override
  void initState() {
    super.initState();
    customer_list.clear();
    totalPaid = 0.0;
    totalSelling = 0.0;
  }

  @override
  void dispose() {
    customer_list.clear();
    totalPaid = 0.0;
    totalSelling = 0.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        screenTitle('Account Report', FontWeight.bold, 20, Colors.black),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Rs. $totalSelling',
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Row(
                          children: [
                            (account_type == 'customer')
                                ? const Text(
                                    'Received',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Paid',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Rs. $totalPaid',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Left',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Rs. ${totalSelling - totalPaid}',
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                );
              }
            }),
        const Divider(),
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 2 - 20,
                child: ElevatedButton(
                    onPressed: () {
                      account_type = 'customer';
                      customer_list.clear();
                      setState(() {});
                    },
                    child: const Text('Customer'))),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Container(
                width: MediaQuery.of(context).size.width / 2 - 20,
                child: ElevatedButton(
                    onPressed: () {
                      account_type = 'seller';
                      customer_list.clear();
                      setState(() {});
                    },
                    child: const Text('Seller'))),
          ],
        ),
        const Divider(),
        if (account_type == 'customer')
          FutureBuilder(
              future: retrieveTodaySellingInvoiceDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("Loading"),
                  );
                } else {
                  return Table(
                      border: TableBorder.all(color: Colors.green, width: 1.5),
                      children: createCustomerTableRow());
                }
              })
        else
          FutureBuilder(
              future: retrieveTodaySellingInvoiceDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("Loading"),
                  );
                } else {
                  return Table(
                      border: TableBorder.all(color: Colors.green, width: 1.5),
                      children: createSellerTableRow());
                }
              })
      ],
    );
  }
}
