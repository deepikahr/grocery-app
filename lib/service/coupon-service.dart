import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class CouponService {
  static final Client client = Client();
  // get coupons

  static Future<Map<String, dynamic>> applyCouponsCode(
      cartId, couponCode) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    var body = {"couponCode": couponCode.toString()};
    final response = await client.post(
        Constants.baseURL + "cart/apply/coupon/$cartId",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> removeCoupon(cartId) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.baseURL + "cart/remove/coupon/$cartId", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    return json.decode(response.body);
  }
}
