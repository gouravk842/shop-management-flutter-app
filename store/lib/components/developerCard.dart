import 'package:flutter/material.dart';

detailsCard(var image, var label1, var label2, var label3, var label4) {
  return Container(
    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
    decoration: BoxDecoration(
      border: Border.all(),
      /* image: DecorationImage(
          image: AssetImage('assets/images/back.jpg'), fit: BoxFit.cover),*/
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('$image'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          margin: EdgeInsets.all(20),
          width: 85,
          height: 85,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Container(
              width: 200,
              child: Text(
                '$label1',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Divider(),
            Container(
              width: 200,
              child: Text(
                '$label2',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 200,
              child: Text(
                '$label3',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 200,
              child: Text(
                '$label4',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ],
    ),
  );
}
