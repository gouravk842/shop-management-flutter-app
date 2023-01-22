import 'package:flutter/material.dart';
import 'package:store/responsive.dart';

import '../../components/background.dart';
import 'components/PdfInvoice.dart';

class PdfInvoiceScreen extends StatelessWidget {
  final String invoiceNo;
  const PdfInvoiceScreen({Key? key, required this.invoiceNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.topCenter,
      screenTitle: 'Invoice Pdf',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobilePdfInvoiceScreen(
            invoiceNo: invoiceNo,
          ),
          desktop: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}

class MobilePdfInvoiceScreen extends StatelessWidget {
  final String invoiceNo;
  const MobilePdfInvoiceScreen({Key? key, required this.invoiceNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        PdfInvoiceForm(
          invoiceId: invoiceNo,
        )
      ],
    );
  }
}
