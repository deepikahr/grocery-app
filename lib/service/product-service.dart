import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class ProductService {
  // get category list
  static Future<Map<String, dynamic>> getCategoryList() async {
    final response = await client.get(Constants.apiUrl + "categories/list");
    return json.decode(response.body);
  }

  // get all product
  static Future<Map<String, dynamic>> getProductListAll(index, limit) async {
    final response = await client
        .get(Constants.apiUrl + "products/list?limit=$limit&page=$index");
    return json.decode(response.body);
  }

  // get all banner
  static Future<Map<String, dynamic>> getBanner() async {
    final response = await client.get(Constants.apiUrl + "banners/list");
    await Common.setBanner(json.decode(response.body));

    return json.decode(response.body);
  }

  // get all top deal
  static Future<Map<String, dynamic>> getTopDealsListAll() async {
    final response = await client.get(Constants.apiUrl + "deals/top");
    return json.decode(response.body);
  }

  // get all of-the-day deal
  static Future<Map<String, dynamic>> getTodayDealsListAll() async {
    final response = await client.get(Constants.apiUrl + "deals/of-the-day");
    return json.decode(response.body);
  }

  // get product to category list
  static Future<Map<String, dynamic>> getProductToCategoryList(id) async {
    final response =
        await client.get(Constants.apiUrl + "products/category/$id");
    return json.decode(response.body);
  }

  // get product to sub category list
  static Future<Map<String, dynamic>> getProductToSubCategoryList(id) async {
    final response =
        await client.get(Constants.apiUrl + "products/sub-category/$id");
    return json.decode(response.body);
  }

  // product detail
  static Future<Map<String, dynamic>> productDetails(productId) async {
    final response =
        await client.get(Constants.apiUrl + "products/detail/$productId");
    return json.decode(response.body);
  }

  // get all home page data
  static Future<Map<String, dynamic>> getProdCatDealTopDeal() async {
    final response = await client.get(Constants.apiUrl + "Products/home");
    await Common.setAllData(json.decode(response.body));
    return json.decode(response.body);
  }

  // search product
  static Future<dynamic> getSearchList(status) async {
    final response =
        await client.get(Constants.apiUrl + 'products/search?q=$status');
    return json.decode(response.body);
  }

  // get all sub-categories list
  static Future<dynamic> getSubCatList() async {
    final response = await client.get(Constants.apiUrl + 'sub-categories/list');
    return json.decode(response.body);
  }

  // get product rating
  static Future<dynamic> productRating(body) async {
    final response = await client.post(Constants.apiUrl + 'ratings/rate',
        body: json.encode(body));
    return json.decode(response.body);
  }
}
