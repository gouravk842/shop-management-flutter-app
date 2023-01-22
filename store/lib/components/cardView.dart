import 'package:flutter/material.dart';

cardview(double width, String date, String customerName, String invoiceNo,
    String quantity,
    {bool isAdd = true, bool isDate = true, bool isName = false}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      //
      width: width,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border:
            Border.all(color: (isAdd) ? Colors.greenAccent : Colors.redAccent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isDate)
                    Row(
                      children: [
                        const Text(
                          'Date ',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        Text(date)
                      ],
                    ),
                  Row(
                    children: [
                      const Text(
                        'Invoice No ',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Text(invoiceNo)
                    ],
                  ),
                  (isName)
                      ? Row(
                          children: [
                            const Text(
                              'Name ',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Text(customerName)
                          ],
                        )
                      : const Text(''),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: (isAdd)
                      ? Colors.greenAccent.shade100
                      : Colors.redAccent.shade100),
              child: Text(
                quantity,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
