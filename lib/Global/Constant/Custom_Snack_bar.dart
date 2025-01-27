import 'package:flutter/material.dart';

class ProjectSnackBar {
  static void showSnackbar(BuildContext context, String mesage1, String Mesage2) {
    final snackBar = SnackBar(
      backgroundColor: Colors.lightBlue[400],
      content: Column(
        children: [
          Text(
            mesage1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            Mesage2,
          )
        ],
      ),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating, // Snackbar'ı ekranda yüzen hale getirir.
    );
    // ScaffoldMessenger kullanarak SnackBar göster
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
