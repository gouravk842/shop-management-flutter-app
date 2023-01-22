import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/components/currentDate.dart';

import '../../ReportGeneration/TodaySellingReportScreen.dart';

totalSellingAmountAvatar(
  size,
  context,
) {
  return AvatarGlow(
    shape: BoxShape.rectangle,
    glowColor: Colors.blue,
    endRadius: 80.0,
    duration: const Duration(milliseconds: 2000),
    repeat: true,
    showTwoGlows: false,
    repeatPauseDuration: const Duration(milliseconds: 100),
    child: GestureDetector(
      child: Container(
        height: size.height * 0.1,
        width: size.width * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('invoice')
                    .where("bill_date", isEqualTo: currentDate())
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> querySnapshot) {
                  if (querySnapshot.hasError) {
                    return const Text('some error');
                  } else if (querySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading....');
                  } else {
                    final l = querySnapshot.data!.docs;
                    double totalAmount = 0.0;
                    for (var element in l) {
                      if (element['invoice_type'] == 'customer') {
                        totalAmount += element.get('total_amount');
                      }
                    }
                    return (l.isEmpty)
                        ? const Text(
                            '0',
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          )
                        : Text(
                            'Rs $totalAmount',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.blue),
                          );
                  }
                }),
            const Text(
              'Today Sell',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TodaySellingReportGenerationScreen();
            },
          ),
        );
      },
    ),
  );
}
