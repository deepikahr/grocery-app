import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:readymade_grocery_app/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

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
