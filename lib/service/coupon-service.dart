import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

class CouponService {
  // get coupons

  static Future<Map<String, dynamic>> applyCouponsCode(couponName) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/carts/apply-coupon/$couponName"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> removeCoupon(couponCode) async {
    return client
        .delete(
            Uri.parse(Constants.apiUrl! + "/carts/remove-coupon/$couponCode"))
        .then((response) {
      return json.decode(response.body);
    });
  }
}
