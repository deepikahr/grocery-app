import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class PaymentService {
  // get payment status
  static Future getPaymentStatus(id) async {
    return client
        .get(Constants.apiUrl + "/orders/payment/status/$id")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // cancel order
  static Future orderCancelApi(id) async {
    return client
        .get(Constants.apiUrl + "/orders/cancel/order/$id")
        .then((response) {
      return json.decode(response.body);
    });
  }
}
