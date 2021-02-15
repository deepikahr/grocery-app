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
    return client
        .post(Constants.apiUrl + "/carts/update", body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get product in cart
  static Future<Map<String, dynamic>> getProductToCart() async {
    return client.get(Constants.apiUrl + "/carts/my").then((response) {
      return json.decode(response.body);
    });
  }

  // delete form cart
  static Future<Map<String, dynamic>> deleteDataFromCart(productId) async {
    return client
        .put(Constants.apiUrl + "/carts/remove/$productId")
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> deleteAllDataFromCart() async {
    return client.delete(Constants.apiUrl + "/carts/delete").then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> getDeliveryChargesAndSaveAddress(
      body) async {
    return client
        .post(Constants.apiUrl + "/carts/update-address",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> getShippingMethodAndSave(body) async {
    return client
        .post(Constants.apiUrl + "/carts/update-shipping-method",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> checkCartVerifyOrNot() async {
    return client.get(Constants.apiUrl + "/carts/verify").then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> walletApply() async {
    return client
        .post(Constants.apiUrl + "/carts/apply-wallet")
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> walletRemove() async {
    return client
        .delete(Constants.apiUrl + "/carts/remove-wallet")
        .then((response) {
      return json.decode(response.body);
    });
  }
}
