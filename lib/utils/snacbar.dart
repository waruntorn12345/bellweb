import 'package:flutter/material.dart';

void openSnacbar(GlobalKey<ScaffoldState> scaffoldKey, snacMessage) {
  ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
    SnackBar(
      content: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        child: Text(
          snacMessage,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      action: SnackBarAction(
        label: 'Ok',
        textColor: Colors.blueAccent,
        onPressed: () {},
      ),
    ),
  );
}
