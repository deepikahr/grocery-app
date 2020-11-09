import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readymadeGroceryApp/main.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class AlertService {
  Timer checkConnectionTimer;
  bool isFirstTime = true;
  AppLifecycleState state;
  checkConnectionMethod() async {
    if (checkConnectionTimer != null && checkConnectionTimer.isActive)
      checkConnectionTimer.cancel();
    checkConnectionTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      state = WidgetsBinding.instance.lifecycleState;
      if (state != AppLifecycleState.paused) {
        Common.getNoConnection().then((value) {
          String noInternet = value['NO_INTERNET'] ?? "No Internet connection";
          String onlineMsg = value['ONLINE_MSG'] ?? "Now you are online.";
          String noInternetMsg = value["NO_INTERNET_MSG"] ??
              "requires an internet connection. Chcek you connection then try again.";
          if (connectivityResult == ConnectivityResult.none) {
            isFirstTime = true;
            String msg = "$noInternet\n ${Constants.appName} $noInternetMsg";
            AlertService().showToast(msg);
          } else {
            if (isFirstTime) {
              AlertService().showToast(onlineMsg);
              isFirstTime = false;
            }
            Common.getSplash().then((isFirstTimeSplash) {
              if (isFirstTimeSplash) {
                main();
              }
            });
          }
        });
      }
    });
  }

  showToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: primarybg,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
