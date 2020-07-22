import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import '../service/common.dart';

class CartService {
  static final Client client = Client();

  // add product in cart
  static Future<Map<String, dynamic>> addAndUpdateProduct(body) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "carts/update",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });

    return json.decode(response.body);
  }

  // get product in cart
  static Future<Map<String, dynamic>> getProductToCart() async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.get(Constants.baseURL + "carts/my", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  // delete form cart
  static Future<Map<String, dynamic>> deleteDataFromCart(productId) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .put(Constants.baseURL + "carts/remove/$productId", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> deleteAllDataFromCart() async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.delete(Constants.baseURL + "carts/delete", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> paymentTimeCarDataDelete(Map body) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.put(
        Constants.baseURL + "cart/remove/multi/product",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    print("cart/remove/multi/product");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getDeliveryChargesAndSaveAddress(
      body) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(
        Constants.baseURL + "carts/update-address",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    print("carts/update-address");
    print(json.decode(response.body));
    return json.decode(response.body);
  }
}
