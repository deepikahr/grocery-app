import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class ProductService {
  static final Client client = Client();
  // get category list
  static Future<Map<String, dynamic>> getCategoryList() async {
    final response =
        await client.get(Constants.baseURL + "categories", headers: {
      'Content-Type': 'application/json',
    });
    Common.setCatagrytList(json.decode(response.body));
    return json.decode(response.body);
  }
  // static Future<Map<String, dynamic>> getCategoryList() async {
  //   final response = await client
  //       .get(Constants.baseURL + "products/category/combineData", headers: {
  //     'Content-Type': 'application/json',
  //   });
  //   return json.decode(response.body);
  // }

  static Future<Map<String, dynamic>> getProductsList() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.baseURL + "products/All/Enable/Products", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    Common.setProductList(json.decode(response.body));

    return json.decode(response.body);
  }

  // get product to category
  static Future<Map<String, dynamic>> getProductToCategoryList(id) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.baseURL + "products/by/category/$id", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    return json.decode(response.body);
  }

  //deals
  static Future<Map<String, dynamic>> getDealsList() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.get(Constants.baseURL + "deals", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    return json.decode(response.body);
  }

  // get all locations
  static Future<Map<String, dynamic>> getLocationList() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.get(Constants.baseURL + "locations/all",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  // place order
  static Future<Map<String, dynamic>> placeOrder(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(Constants.baseURL + "orders/place/order",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  // buy now order
  static Future<Map<String, dynamic>> getBuyNowInfor(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });

    final response = await client.post(
        Constants.baseURL + "orders/get/tax/info",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> quickBuyNow(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(Constants.baseURL + "orders/quick/buy",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  // get orders
  static Future<Map<String, dynamic>> getOrderList(status) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.baseURL + "orders/by/status/$status", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    return json.decode(response.body);
  }

//order info by user ID
  static Future<Map<String, dynamic>> getOrderByUserID(userID) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });

    final response = await client.get(
        Constants.baseURL + "orders/history/of/user/mobile/data/$userID",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getRating(id) async {
    String token;
    var body = {"orderId": id};
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(Constants.baseURL + "orders/ratings",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> orderRating(body, orderId) async {
    String token;

    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(
        Constants.baseURL + "orders/ratings/$orderId",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  //get all order list
  static Future<Map<String, dynamic>> getAllOrderList() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.get(Constants.baseURL + "orders/user/all",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  // geo api
  static Future<Map<String, dynamic>> geoApi(lat, lon) async {
    final response = await client.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=AIzaSyD6Q4UgAYOL203nuwNeBr4j_-yAd1U1gko',
        headers: {
          'Content-Type': 'application/json',
        });
    Common.setCurrentLocation(json.decode(response.body));
    return json.decode(response.body);
  }

  //rate to product
  static Future<Map<String, dynamic>> productRate(body) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(
        Constants.baseURL + "rating/rate/product",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> productRating(productId) async {
    final response = await client
        .get(Constants.baseURL + "rating/get/product/$productId", headers: {
      'Content-Type': 'application/json',
    });
    return json.decode(response.body);
  }

  //search product
  static Future<dynamic> getSearchList(status) async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });

    final response = await client
        .get(Constants.baseURL + 'products/search/$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    return json.decode(response.body);
  }
}
