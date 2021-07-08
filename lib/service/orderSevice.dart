import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

class OrderService {
  //order list
  static Future<Map<String, dynamic>> getOrderByUserID(
      orderIndex, orderLimit, type) async {
    return client
        .get(Uri.parse(Constants.apiUrl! +
            "/orders/list?page=$orderIndex&limit=$orderLimit&type=$type"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // place order
  static Future<Map<String, dynamic>> placeOrder(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/orders/create"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // order detail
  static Future<Map<String, dynamic>> getOrderHistory(orderId) async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/orders/detail/$orderId"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // order cancel
  static Future<dynamic> orderCancel(orderId) async {
    return client
        .put(Uri.parse(Constants.apiUrl! + '/orders/cancel/$orderId'))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // delivery boy rating
  static Future<Map<String, dynamic>> deliveryRating(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + '/delivery-boy-ratings/rate'),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  } // delivery boy rating

  static Future<Map<String, dynamic>> addMoneyApi(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + '/wallets/add/money'),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }
}
