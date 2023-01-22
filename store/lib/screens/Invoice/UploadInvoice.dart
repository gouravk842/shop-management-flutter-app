import 'package:flutter/material.dart';
import 'package:store/responsive.dart';

import '../../components/background.dart';
import 'components/uploadForm.dart';

class UploadInvoiceScreen extends StatelessWidget {
  const UploadInvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.center,
      screenTitle: 'Invoice Entry Panel',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileUploadInvoiceScreen(),
          desktop: Row(
            children: [UploadInvoice()],
          ),
        ),
      ),
    );
  }
}

class MobileUploadInvoiceScreen extends StatelessWidget {
  const MobileUploadInvoiceScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[UploadInvoice()],
    );
  }
}
