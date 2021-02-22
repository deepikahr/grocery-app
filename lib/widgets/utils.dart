import 'package:flutter/material.dart';

class UtilService{
  static void navigateBack(BuildContext context, {result}) {
    return Navigator.pop(context, result);
  }

  static Future navigateTo(BuildContext context, Widget screen) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static Future navigateToAndPopAll(BuildContext context, Widget screen) {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => screen,
        ),
            (Route<dynamic> route) => false);
  }
}