import 'package:flutter/material.dart';
import 'package:store/responsive.dart';

import '../../components/background.dart';
import 'components/sellerInvoiceForm.dart';

class SellingInvoiceScreen extends StatelessWidget {
  const SellingInvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.center,
      screenTitle: 'Selling Invoice Panel',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileSellingInvoiceScreen(),
          desktop: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}

class MobileSellingInvoiceScreen extends StatelessWidget {
  const MobileSellingInvoiceScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[SellingInvoiceForm()],
    );
  }
}
