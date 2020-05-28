import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class PaymentService {
  static final Client client = Client();
  static Future<Map<String, dynamic>> getDeliveryCharges(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(
        Constants.baseURL + "delivery/tax/settings/get/charges",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }
}
