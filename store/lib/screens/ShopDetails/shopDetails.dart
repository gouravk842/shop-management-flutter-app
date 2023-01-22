import 'package:flutter/material.dart';
import 'package:store/components/background.dart';
import 'package:store/responsive.dart';

import 'components/shopDetailsEditForm.dart';

class ShopDetailsScreen extends StatelessWidget {
  const ShopDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      alignment: Alignment.center,
      screenTitle: 'Shop Details',
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
            mobile: const MobileShopDetailsScreen(),
          ),
        ),
      ),
    );
  }
}

class MobileShopDetailsScreen extends StatelessWidget {
  const MobileShopDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[ShopDetailsForm()],
    );
  }
}
