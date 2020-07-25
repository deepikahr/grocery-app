import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'dart:convert';
import 'constants.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class CartService {
  // add product in cart
  static Future<Map<String, dynamic>> addAndUpdateProduct(body) async {
    final response = await client.post(Constants.apiUrl + "carts/update",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // get product in cart
  static Future<Map<String, dynamic>> getProductToCart() async {
    final response = await client.get(Constants.apiUrl + "carts/my");
    return json.decode(response.body);
  }

  // delete form cart
  static Future<Map<String, dynamic>> deleteDataFromCart(productId) async {
    final response =
        await client.put(Constants.apiUrl + "carts/remove/$productId");
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> deleteAllDataFromCart() async {
    final response = await client.delete(Constants.apiUrl + "carts/delete");

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getDeliveryChargesAndSaveAddress(
      body) async {
    final response = await client.post(
        Constants.apiUrl + "carts/update-address",
        body: json.encode(body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> checkCartVerifyOrNot() async {
    final response = await client.get(Constants.apiUrl + "carts/verify");
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> walletApply() async {
    final response = await client.post(Constants.apiUrl + "carts/apply-wallet");
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> walletRemove() async {
    final response =
        await client.delete(Constants.apiUrl + "carts/remove-wallet");
    return json.decode(response.body);
  }
}
