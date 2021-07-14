import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'dart:convert';
import 'constants.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

class AddressService {
  // add address
  static Future<Map<String, dynamic>> addAddress(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/address/create"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get address
  static Future<Map<String, dynamic>> getAddress() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/address/list"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  //getDeliverySlots
  static Future<Map<String, dynamic>> deliverySlot() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/settings/delivery-time-slots"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // update address
  static Future<Map<String, dynamic>> updateAddress(body, addressId) async {
    return client
        .put(Uri.parse(Constants.apiUrl! + "/address/update/$addressId"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // delete address
  static Future<Map<String, dynamic>> deleteAddress(addressId) async {
    return client
        .delete(Uri.parse(Constants.apiUrl! + "/address/delete/$addressId"))
        .then((response) {
      return json.decode(response.body);
    });
  }
}
