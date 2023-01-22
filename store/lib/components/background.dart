import 'dart:math';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String screenTitle;
  final Alignment alignment;
  final Widget bottomNavigationBar;
  const Background({
    Key? key,
    required this.child,
    required this.screenTitle,
    required this.alignment,
    this.bottomNavigationBar = const Text(''),
    this.topImage = "assets/images/main_top.png",
    this.bottomImage = "assets/images/login_bottom.png",
  }) : super(key: key);

  final String topImage, bottomImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
      ),
      resizeToAvoidBottomInset: true,
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Drawer(
          child: ListView(
            children: <Widget>[
              Center(
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.lightBlue.shade400,
                    Colors.lightGreen.shade100
                  ])),
                  accountName: const Text("passed_name"),
                  accountEmail: const Text("{user.email}"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: const NetworkImage(
                        "https://images.unsplash.com/photo-1667407226498-c06b03df35a8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80"),
                    key: ValueKey(Random().nextInt(100)),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: alignment,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                topImage,
                width: 120,
              ),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
