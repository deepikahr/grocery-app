import 'package:flutter/material.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/constants.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

SentryError sentryError = new SentryError();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  getToken() async {
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        checkToken(onValue);
      } else {}
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  checkToken(token) async {
    await LoginService.checkToken().then((onValue) {
      print(onValue);
      try {
        if (onValue['response_data']['tokenVerify'] == false) {
          Common.setToken(null).then((onValue) {
            print(onValue);
          }).catchError((error) {
            sentryError.reportError(error, null);
          });
        } else {}
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Readymade Grocery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
