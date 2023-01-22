import 'package:flutter/material.dart';
import 'package:store/responsive.dart';

import '../../components/background.dart';
import 'component/CustomerAccountReport.dart';

class CustomerAccountReportGenerationScreen extends StatelessWidget {
  const CustomerAccountReportGenerationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.topCenter,
      screenTitle: 'Account Report',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const CustomerAccountReportMobileScreen(),
          desktop: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}

class CustomerAccountReportMobileScreen extends StatelessWidget {
  const CustomerAccountReportMobileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Padding(padding: EdgeInsets.all(10.0), child: CustomerAccountReport())
      ],
    );
  }
}
