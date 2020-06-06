import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class CounterModel with ChangeNotifier {
  var cartData;
  getCartDataMethod() async {
    await CartService.getProductToCart().then((onValue) {
      try {
        if (onValue['response_code'] == 200 &&
            onValue['response_data'] is Map) {
          cartData = onValue['response_data'];
        } else {
          cartData = null;
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    });
    return cartData;
  }

  void getCatData() {
    getCartDataMethod();
    notifyListeners();
  }
}
