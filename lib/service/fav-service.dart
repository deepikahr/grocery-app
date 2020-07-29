import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class FavouriteService {
  //add to fav
  static Future<Map<String, dynamic>> addToFav(id) async {
    return client
        .post(Constants.apiUrl + "/favourites/add/$id")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get fav
  static Future<Map<String, dynamic>> getFavList() async {
    return client.get(Constants.apiUrl + "/favourites/list").then((response) {
      return json.decode(response.body);
    });
  }

  //delete to fav
  static Future<Map<String, dynamic>> deleteToFav(id) async {
    return client
        .delete(Constants.apiUrl + "/favourites/remove/$id")
        .then((response) {
      return json.decode(response.body);
    });
  }
}
