import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class ProductService {
  static final Client client = Client();
  // get category list
  static Future<Map<String, dynamic>> getCategoryList() async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response =
        await client.get(Constants.baseURL + "categories/list", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getProductListAll(index, limit) async {
    String languageCode, token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response = await client.get(
        Constants.baseURL + "products/list?limit=$limit&page=$index",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getBanner() async {
    String languageCode, token;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    final response =
        await client.get(Constants.baseURL + "banners/list", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    await Common.setBanner(json.decode(response.body));

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getTopDealsListAll() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response =
        await client.get(Constants.baseURL + "deals/top", headers: {
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

    final response =
        await client.get(Constants.baseURL + "deals/of-the-day", headers: {
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

    final response =
        await client.get(Constants.baseURL + "products/category/$id", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  // get product to category
  static Future<Map<String, dynamic>> getProductToSubCategoryList(id) async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });

    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response = await client
        .get(Constants.baseURL + "products/sub-category/$id", headers: {
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

    final response = await client.post(Constants.baseURL + "orders/create",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    print("/orders/create");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

//order info by user ID
  static Future<Map<String, dynamic>> getOrderByUserID() async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response =
        await client.get(Constants.baseURL + "orders/list", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    print("/orders/list");
    print(json.decode(response.body));
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
    print("orders/ratings/$orderId");
    print(json.decode(response.body));
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
    print("rating/rate/product");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> productDetails(productId) async {
    String languageCode, token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response = await client
        .get(Constants.baseURL + "products/detail/$productId", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
      'Authorization': 'bearer $token',
    });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getProdCatDealTopDeal() async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response =
        await client.get(Constants.baseURL + "Products/home", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
      'Authorization': 'bearer $token',
    });
    await Common.setAllData(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<dynamic> getSearchList(status) async {
    String token, languageCode;

    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.baseURL + 'products/search?q=$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  static Future<dynamic> getSubCatList() async {
    String languageCode, token;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.baseURL + 'sub-categories/list', headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
      'Authorization': 'bearer $token',
    });
    return json.decode(response.body);
  }
}
