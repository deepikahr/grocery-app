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
    final response =
        await client.post(Constants.baseURL + "favourites/add/$id");
    return json.decode(response.body);
  }

  // get fav
  static Future<Map<String, dynamic>> getFavList() async {
    final response = await client.get(Constants.baseURL + "favourites/list");
    return json.decode(response.body);
  }

  //delete to fav
  static Future<Map<String, dynamic>> deleteToFav(id) async {
    final response =
        await client.delete(Constants.baseURL + "favourites/remove/$id");
    return json.decode(response.body);
  }
}
