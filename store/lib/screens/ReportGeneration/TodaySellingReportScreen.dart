import 'package:flutter/material.dart';
import 'package:store/responsive.dart';

import '../../components/background.dart';
import 'component/TodaySellingReport.dart';

class TodaySellingReportGenerationScreen extends StatelessWidget {
  const TodaySellingReportGenerationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.topCenter,
      screenTitle: 'Product Report',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileTodaySellingReportPanelScreen(),
          desktop: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}

class MobileTodaySellingReportPanelScreen extends StatelessWidget {
  const MobileTodaySellingReportPanelScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Padding(padding: EdgeInsets.all(10.0), child: TodaySellingReport())
      ],
    );
  }
}
