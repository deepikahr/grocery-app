import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class AddressService {
  static final Client client = Client();

  // add address
  static Future<Map<String, dynamic>> addAddress(body) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    print(token);
    final response = await client.post(Constants.baseURL + "address/create",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    print("/address/create");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  // get address
  static Future<Map<String, dynamic>> getAddress() async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.baseURL + "address/list", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

//getDeliverySlots
  static Future<Map<String, dynamic>> deliverySlot(time, timeStamp) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.get(
        Constants.baseURL + "setting/user/working/time/$time/$timeStamp",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });

    return json.decode(response.body);
  }

  // update address
  static Future<Map<String, dynamic>> updateAddress(body, addressId) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    print(token);

    final response = await client.put(
        Constants.baseURL + "address/update/$addressId",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });

    print("address/update/$addressId");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  // delete address
  static Future<Map<String, dynamic>> deleteAddress(addressId) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .delete(Constants.baseURL + "address/delete/$addressId", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }
}
