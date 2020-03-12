import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import '../service/common.dart';

class CartService {
  static final Client client = Client();

  // add product in cart
  static Future<Map<String, dynamic>> addProductToCart(body) async {
    String token;
    print(body);
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(Constants.baseURL + "cart/add/product",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  // get product in cart
  static Future<Map<String, dynamic>> getProductToCart() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.get(Constants.baseURL + "cart/user/items",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  // update product in cart
  static Future<Map<String, dynamic>> updateProductToCart(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.put(Constants.baseURL + "cart/update/product",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  // delete form cart
  static Future<Map<String, dynamic>> deleteDataFromCart(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.put(Constants.baseURL + "cart/delete/product",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    print('000000000000000000000000000000');
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> deleteAllDataFromCart(cartId) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .delete(Constants.baseURL + "cart/all/items/$cartId", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    return json.decode(response.body);
  }
}
