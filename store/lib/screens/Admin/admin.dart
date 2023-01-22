import 'package:flutter/material.dart';
import 'package:store/components/background.dart';

import 'package:store/responsive.dart';

import 'package:store/screens/Admin/components/admin_top_image.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.center,
      screenTitle: 'Admin Panel',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(),
          desktop: Row(
            children: const [],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatefulWidget {
  @override
  _MobileState createState() => _MobileState();
}

final companyNameController = TextEditingController();

class _MobileState extends State<MobileLoginScreen> {
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const AdminScreenTopImage(),
          Hero(
            tag: "add_shop_details",
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'shopDetails');
              },
              child: const Text("Shop Details"),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Hero(
            tag: "add_company_btn",
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'addCompany');
              },
              child: const Text("Add Company"),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Hero(
            tag: "add_product_btn",
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'addProduct');
              },
              child: const Text("Add Product"),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Hero(
            tag: "add_invoice_btn",
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'uploadInvoice');
              },
              child: const Text("Add Invoice"),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Hero(
            tag: "selling_invoice_btn",
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'sellingInvoice');
              },
              child: const Text("Selling Invoice"),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Hero(
            tag: "report_generation_btn",
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'reportPanel');
              },
              child: const Text("Report Generation"),
            ),
          ),
        ],
      ),
    );
  }
}
