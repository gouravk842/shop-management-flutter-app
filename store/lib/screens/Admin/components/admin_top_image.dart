import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:store/screens/Admin/components/total_invoice_avatar.dart';
import 'package:store/components/currentDate.dart';
import 'package:store/screens/Admin/components/total_selling_amount_avatar.dart';

import '../../../constants.dart';

class AdminScreenTopImage extends StatelessWidget {
  const AdminScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          "Admin Panel".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // totalInvoiceAvatar(size, context),
            totalSellingAmountAvatar(size, context)
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
