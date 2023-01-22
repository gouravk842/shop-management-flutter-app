import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/components/currentDate.dart';

totalInvoiceAvatar(
  size,
  context,
) {
  return AvatarGlow(
    glowColor: Colors.blue,
    endRadius: 50.0,
    duration: const Duration(milliseconds: 2000),
    repeat: true,
    showTwoGlows: false,
    repeatPauseDuration: const Duration(milliseconds: 100),
    child: GestureDetector(
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.25,
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
                    return (l.isEmpty)
                        ? const Text(
                            '0',
                            style: TextStyle(fontSize: 30, color: Colors.blue),
                          )
                        : Text(
                            '${l.length}',
                            style: const TextStyle(
                                fontSize: 30, color: Colors.blue),
                          );
                  }
                }),
            const Text(
              'Today Invoice',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, "listview");
      },
    ),
  );
}
