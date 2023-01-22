import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addCompany(String companyName) async {
  await FirebaseFirestore.instance.collection("profile").doc("company").update({
    'Name': FieldValue.arrayUnion([companyName]),
  });
}
