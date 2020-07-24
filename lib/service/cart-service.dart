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
    final response = await client.post(Constants.baseURL + "carts/update",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // get product in cart
  static Future<Map<String, dynamic>> getProductToCart() async {
    final response = await client.get(Constants.baseURL + "carts/my");
    return json.decode(response.body);
  }

  // delete form cart
  static Future<Map<String, dynamic>> deleteDataFromCart(productId) async {
    final response =
        await client.put(Constants.baseURL + "carts/remove/$productId");
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> deleteAllDataFromCart() async {
    final response = await client.delete(Constants.baseURL + "carts/delete");

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getDeliveryChargesAndSaveAddress(
      body) async {
    final response = await client.post(
        Constants.baseURL + "carts/update-address",
        body: json.encode(body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> checkCartVerifyOrNot() async {
    final response = await client.get(Constants.baseURL + "carts/verify");
    return json.decode(response.body);
  }
}
