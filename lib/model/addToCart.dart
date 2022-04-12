import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/error-service.dart';

ReportError reportError = new ReportError();

class AddToCart {
  static Future<Map<String, dynamic>> addAndUpdateProductMethod(
      buyNowProduct) async {
    final response = await CartService.addAndUpdateProduct(buyNowProduct);
    return response;
  }
}
