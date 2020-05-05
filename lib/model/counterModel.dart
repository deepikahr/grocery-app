import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class CounterModel with ChangeNotifier {
  var cartData;
  getCartDataMethod() async {
    await CartService.getProductToCart().then((onValue) {
      try {
        if (onValue['response_data'] == 'You have not added items to cart') {
          cartData = null;
        } else {
          cartData = onValue['response_data'];
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
