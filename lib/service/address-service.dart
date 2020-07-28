import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class AddressService {
  // add address
  static Future<Map<String, dynamic>> addAddress(body) async {
    return client
        .post(Constants.apiUrl + "/address/create", body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get address
  static Future<Map<String, dynamic>> getAddress() async {
    return client.get(Constants.apiUrl + "/address/list").then((response) {
      return json.decode(response.body);
    });
  }

  //getDeliverySlots
  static Future<Map<String, dynamic>> deliverySlot() async {
    return client
        .get(Constants.apiUrl + "/settings/delivery-time-slots")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // update address
  static Future<Map<String, dynamic>> updateAddress(body, addressId) async {
    return client
        .put(Constants.apiUrl + "/address/update/$addressId",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // delete address
  static Future<Map<String, dynamic>> deleteAddress(addressId) async {
    return client
        .delete(Constants.apiUrl + "/address/delete/$addressId")
        .then((response) {
      return json.decode(response.body);
    });
  }
}
