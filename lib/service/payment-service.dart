import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class PaymentService {
  static final Client client = Client();
  // get card list
  static Future<Map<String, dynamic>> getCardList() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.baseURL + "payment-method/get/user/cards", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    Common.setCardInfo(json.decode(response.body));
    return json.decode(response.body);
  }

  // save card
  static Future<Map<String, dynamic>> saveCard(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(
        Constants.baseURL + "payment-method/save/card",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  //delete card
  static Future<Map<String, dynamic>> deleteCard(cardId) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.delete(
        Constants.baseURL + "payment-method/delete/card/$cardId",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

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
