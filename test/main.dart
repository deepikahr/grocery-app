import 'package:readymadeGroceryApp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  final DataHandler handler = (_) async {
    return Future.value(null);
  };
  enableFlutterDriverExtension(handler: handler);
  WidgetsApp.debugAllowBannerOverride = false;
  initializeMain(isTest: true);
}
