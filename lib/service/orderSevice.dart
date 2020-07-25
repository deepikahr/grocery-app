import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class OrderService {
  //order list
  static Future<Map<String, dynamic>> getOrderByUserID() async {
    final response = await client.get(Constants.apiUrl + "orders/list");
    return json.decode(response.body);
  }

  // place order
  static Future<Map<String, dynamic>> placeOrder(body) async {
    final response = await client.post(Constants.apiUrl + "orders/create",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // order detail
  static Future<Map<String, dynamic>> getOrderHistory(orderId) async {
    final response =
        await client.get(Constants.apiUrl + "orders/detail/$orderId");
    return json.decode(response.body);
  }

  // order cancel
  static Future<dynamic> orderCancel(orderId) async {
    final response =
        await client.put(Constants.apiUrl + 'orders/cancel/$orderId');
    return json.decode(response.body);
  }
}
