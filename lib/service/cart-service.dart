import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

class CartService {
  // add product in cart
  static Future<Map<String, dynamic>> addAndUpdateProduct(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/carts/update"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // add subscription
  static Future<Map<String, dynamic>> subscribeProductAdd(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/subscriptions/add"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  } //  update subscription

  static Future<Map<String, dynamic>> subscribeProductUpdate(
      body, subscriptionId) async {
    return client
        .put(Uri.parse(Constants.apiUrl! + "/subscriptions/$subscriptionId"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get product in cart
  static Future<Map<String, dynamic>> getProductToCart() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/carts/my"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // delete form cart
  static Future<Map<String, dynamic>> deleteDataFromCart(productId) async {
    return client
        .put(Uri.parse(Constants.apiUrl! + "/carts/remove/$productId"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> deleteAllDataFromCart() async {
    return client
        .delete(Uri.parse(Constants.apiUrl! + "/carts/delete"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> getDeliveryChargesAndSaveAddress(
      body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/carts/update-address"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> getShippingMethodAndSave(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/carts/update-shipping-method"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> checkCartVerifyOrNot() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/carts/verify"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> walletApply() async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/carts/apply-wallet"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<Map<String, dynamic>> walletRemove() async {
    return client
        .delete(Uri.parse(Constants.apiUrl! + "/carts/remove-wallet"))
        .then((response) {
      return json.decode(response.body);
    });
  }
}
