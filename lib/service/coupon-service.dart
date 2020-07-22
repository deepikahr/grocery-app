import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class CouponService {
  static final Client client = Client();
  // get coupons

  static Future<Map<String, dynamic>> applyCouponsCode(couponName) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .post(Constants.baseURL + "carts/apply-coupon/$couponName", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    print("carts/apply-coupon/$couponName");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> removeCoupon(couponCode) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.delete(
        Constants.baseURL + "carts/remove-coupon/$couponCode",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    print("/carts/remove-coupon");
    print(json.decode(response.body));
    return json.decode(response.body);
  }
}
