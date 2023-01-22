import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

details_card(name, description) {
  return Column(
    children: [
      Card(
        color: Colors.blue[200],
        shadowColor: Colors.amber,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          // leading: const CircleAvatar(child: Icon(Icons.house_sharp)),
          title: Text("$name"),
          subtitle: Text("$description"),
          trailing: const Icon(Icons.delete),
        ),
      ),
    ],
  );
}
