import 'package:flutter/material.dart';

import '../ui/pages/home_page/home_page.dart';

class AppUtils {
  static void message(BuildContext context, message, int duration, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: Duration(seconds: duration.toInt()),
      ),
    );
  }

static void toHome(BuildContext context){
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const MyHomePage()),
    (Route<dynamic> route) => false,
  );
}
}