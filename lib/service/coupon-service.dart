import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class CouponService {
  static final Client client = Client();
  // get coupons
  static Future<Map<String, dynamic>> getCoupons() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.get(Constants.baseURL + "coupons/all",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> applyCoupons(couponId) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.baseURL + "cart/apply/coupon/$couponId", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    return json.decode(response.body);
  }
}
