import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class CouponService {
  // get coupons

  static Future<Map<String, dynamic>> applyCouponsCode(couponName) async {
    final response =
        await client.post(Constants.apiUrl + "carts/apply-coupon/$couponName");
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> removeCoupon(couponCode) async {
    final response = await client
        .delete(Constants.apiUrl + "carts/remove-coupon/$couponCode");
    return json.decode(response.body);
  }
}
