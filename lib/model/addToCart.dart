import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class AddToCart {
  static Future<Map<String, dynamic>> addToCartMethod(buyNowProduct) async {
    final response = await CartService.addProductToCart(buyNowProduct);
    return response;
  }
}
