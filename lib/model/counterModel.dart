import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class CounterModel with ChangeNotifier {
  Map? cartData;
  int? cartCount;
  getCartDataMethod() async {
    await Common.getCartData().then((onValue) {
      if (onValue != null) {
        cartData = onValue;
        Common.setCartDataCount(onValue['products'].length ?? 0);
      } else {
        cartData = null;
        Common.setCartDataCount(0);
      }
    });
    return cartData;
  }

  getCartDataCountMethod() async {
    await Common.getCartData().then((onValue) {
      if (onValue != null) {
        cartCount = onValue['products'].length ?? 0;
        Common.setCartDataCount(onValue['products'].length ?? 0);
      } else {
        cartCount = 0;
        Common.setCartDataCount(0);
      }
    });
    return cartCount;
  }

  void getCatData() {
    getCartDataMethod();
    getCartDataCountMethod();
    notifyListeners();
  }
}
