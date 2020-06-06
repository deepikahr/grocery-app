import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class ProductService {
  static final Client client = Client();
  // get category list
  static Future<Map<String, dynamic>> getCategoryList() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "products/home/category", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getProductListAll(index) async {
    String productIndex = "page=" + "$index";
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response = await client.get(
        Constants.baseURL + "products/home/product?$productIndex",
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getProductListAllCartAdded(index) async {
    String userId, languageCode;
    await Common.getUserID().then((uid) {
      userId = "userId=" + uid;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    String productIndex = "page=" + "$index";
    final response = await client.get(
        Constants.baseURL + "products/home/product?$userId&$productIndex",
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getTopDealsListAll() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "products/home/top/deal", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getTodayDealsListAll() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "products/home/deal/of/day", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  // get product to category
  static Future<Map<String, dynamic>> getProductToCategoryList(id) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "products/by/category/$id", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  // get product to category
  static Future<Map<String, dynamic>> getProductToCategoryListCartAdded(
      id) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    String userId;
    await Common.getUserID().then((uid) {
      userId = "userId=" + uid;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "products/by/category/$id?$userId", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getProductToSubCategoryList(id) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response = await client
        .get(Constants.baseURL + "products/by/subcategory/$id", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  // get product to category
  static Future<Map<String, dynamic>> getProductToSubCategoryListCartAdded(
      id) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    String userId;
    await Common.getUserID().then((uid) {
      userId = "userId=" + uid;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.get(
        Constants.baseURL + "products/by/subcategory/$id?$userId",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });

    return json.decode(response.body);
  }

  // place order
  static Future<Map<String, dynamic>> placeOrder(body) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "orders/place/order",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

//order info by user ID
  static Future<Map<String, dynamic>> getOrderByUserID(userID) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response = await client.get(
        Constants.baseURL + "orders/history/of/user/mobile/data/$userID",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> orderRating(body, orderId) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(
        Constants.baseURL + "orders/ratings/$orderId",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  //rate to product
  static Future<Map<String, dynamic>> productRate(body) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(
        Constants.baseURL + "rating/rate/product",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> productRating(productId) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "rating/get/product/$productId", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> productDetailsLogin(productId) async {
    String userId, languageCode;
    await Common.getUserID().then((uid) {
      userId = "userId=" + uid;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "products/info/$productId?$userId", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> productDetailsWithoutLogin(
      productId) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "products/info/$productId", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getProdCatDealTopDeal() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.baseURL + "products/home/page", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    await Common.setAllData(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getProdCatDealTopDealQuary() async {
    String userId, languageCode;
    await Common.getUserID().then((uid) {
      userId = "userId=" + uid;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "products/home/page?$userId", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    await Common.setAllDataQuary(json.decode(response.body));
    return json.decode(response.body);
  }

  //search product
  static Future<dynamic> getSearchList(status) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + 'products/search/$status', headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<dynamic> getSearchListCartAdded(status) async {
    String userId, languageCode;
    await Common.getUserID().then((uid) {
      userId = "userId=" + uid;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + 'products/search/$status?$userId', headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    return json.decode(response.body);
  }
}
