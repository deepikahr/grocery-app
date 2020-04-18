import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class FavouriteService {
  static final Client client = Client();

  //add to fav
  static Future<Map<String, dynamic>> addToFav(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(Constants.baseURL + "favourites",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  // get fav
  static Future<Map<String, dynamic>> getFavList() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });

    final response = await client.get(Constants.baseURL + "favourites/user",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    Common.setFavList(json.decode(response.body));

    return json.decode(response.body);
  }

  //delete to fav
  static Future<Map<String, dynamic>> deleteToFav(id) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.delete(Constants.baseURL + "favourites/$id",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> checkFavProduct(id) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.get(Constants.baseURL + "favourites/$id",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }
}
