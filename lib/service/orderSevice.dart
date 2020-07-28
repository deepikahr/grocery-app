import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class OrderService {
  //order list
  static Future<Map<String, dynamic>> getOrderByUserID(
      orderIndex, orderLimit) async {
    return client
        .get(Constants.apiUrl +
            "/orders/list?limit=$orderLimit&page=$orderIndex")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // place order
  static Future<Map<String, dynamic>> placeOrder(body) async {
    return client
        .post(Constants.apiUrl + "/orders/create", body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // order detail
  static Future<Map<String, dynamic>> getOrderHistory(orderId) async {
    return client
        .get(Constants.apiUrl + "/orders/detail/$orderId")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // order cancel
  static Future<dynamic> orderCancel(orderId) async {
    return client
        .put(Constants.apiUrl + '/orders/cancel/$orderId')
        .then((response) {
      return json.decode(response.body);
    });
  }
}
