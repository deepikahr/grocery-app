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
    final response = await client.post(Constants.baseURL + "address/create",
        body: json.encode(body));

    return json.decode(response.body);
  }

  // get address
  static Future<Map<String, dynamic>> getAddress() async {
    final response = await client.get(Constants.baseURL + "address/list");
    return json.decode(response.body);
  }

  //getDeliverySlots
  static Future<Map<String, dynamic>> deliverySlot() async {
    final response =
        await client.get(Constants.baseURL + "settings/delivery-time-slots");
    return json.decode(response.body);
  }

  // update address
  static Future<Map<String, dynamic>> updateAddress(body, addressId) async {
    final response = await client.put(
        Constants.baseURL + "address/update/$addressId",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // delete address
  static Future<Map<String, dynamic>> deleteAddress(addressId) async {
    final response =
        await client.delete(Constants.baseURL + "address/delete/$addressId");
    return json.decode(response.body);
  }
}
