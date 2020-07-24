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
    final response = await client.get(Constants.baseURL + "categories/list");
    return json.decode(response.body);
  }

  // get all product
  static Future<Map<String, dynamic>> getProductListAll(index, limit) async {
    final response = await client
        .get(Constants.baseURL + "products/list?limit=$limit&page=$index");
    return json.decode(response.body);
  }

  // get all banner
  static Future<Map<String, dynamic>> getBanner() async {
    final response = await client.get(Constants.baseURL + "banners/list");
    await Common.setBanner(json.decode(response.body));

    return json.decode(response.body);
  }

  // get all top deal
  static Future<Map<String, dynamic>> getTopDealsListAll() async {
    final response = await client.get(Constants.baseURL + "deals/top");
    return json.decode(response.body);
  }

  // get all of-the-day deal
  static Future<Map<String, dynamic>> getTodayDealsListAll() async {
    final response = await client.get(Constants.baseURL + "deals/of-the-day");
    return json.decode(response.body);
  }

  // get product to category list
  static Future<Map<String, dynamic>> getProductToCategoryList(id) async {
    final response =
        await client.get(Constants.baseURL + "products/category/$id");
    return json.decode(response.body);
  }

  // get product to sub category list
  static Future<Map<String, dynamic>> getProductToSubCategoryList(id) async {
    final response =
        await client.get(Constants.baseURL + "products/sub-category/$id");
    return json.decode(response.body);
  }

  // product detail
  static Future<Map<String, dynamic>> productDetails(productId) async {
    final response =
        await client.get(Constants.baseURL + "products/detail/$productId");
    return json.decode(response.body);
  }

  // get all home page data
  static Future<Map<String, dynamic>> getProdCatDealTopDeal() async {
    final response = await client.get(Constants.baseURL + "Products/home");
    await Common.setAllData(json.decode(response.body));
    return json.decode(response.body);
  }

  // search product
  static Future<dynamic> getSearchList(status) async {
    final response =
        await client.get(Constants.baseURL + 'products/search?q=$status');
    return json.decode(response.body);
  }

  // get all sub-categories list
  static Future<dynamic> getSubCatList() async {
    final response =
        await client.get(Constants.baseURL + 'sub-categories/list');
    return json.decode(response.body);
  }

  //rate to product
  static Future<Map<String, dynamic>> productRate(body) async {
    final response =
        await client.post(Constants.baseURL + "rating/rate/product");
    print("rating/rate/product");
    print(json.decode(response.body));
    return json.decode(response.body);
  }
}
