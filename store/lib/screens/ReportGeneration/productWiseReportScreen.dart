import 'package:flutter/material.dart';
import 'package:store/responsive.dart';

import '../../components/background.dart';
import 'component/ProductWiseReport.dart';

class ProductWiseReportGenerationScreen extends StatelessWidget {
  const ProductWiseReportGenerationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.topCenter,
      screenTitle: 'Product Report',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileReportPanelScreen(),
          desktop: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}

class MobileReportPanelScreen extends StatelessWidget {
  const MobileReportPanelScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Padding(padding: EdgeInsets.all(10.0), child: ProductWiseReport())
      ],
    );
  }
}
