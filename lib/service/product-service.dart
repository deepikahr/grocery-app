import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

class ProductService {
  // get category list
  static Future<Map<String, dynamic>> getCategoryList() async {
    return await client
        .get(Uri.parse(Constants.apiUrl! + "/categories/list"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get all product
  static Future<Map<String, dynamic>> getProductListAll(index, limit) async {
    return client
        .get(Uri.parse(
            Constants.apiUrl! + "/products/list?limit=$limit&page=$index"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<dynamic> getSubscriptionList(index, limit) async {
    return client
        .get(Uri.parse(Constants.apiUrl! +
            "/products/list/subscription?limit=$limit&page=$index"))
        .then((response) {
      Common.setSubcriptionData(json.decode(response.body));
      return json.decode(response.body);
    });
  }

  // get all deal products
  static Future<Map<String, dynamic>> getDealProductListAll(
    dealId,
    index,
    limit,
  ) async {
    return client
        .get(Uri.parse(Constants.apiUrl! +
            "/deals/products/$dealId?limit=$limit&page=$index"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get all banner
  static Future<Map<String, dynamic>?> getBanner() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/banners/list"))
        .then((response) async {
      await Common.setBanner(json.decode(response.body));

      return json.decode(response.body);
    });
  }

  // get all top deal
  static Future<Map<String, dynamic>> getTopDealsListAll() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/deals/top"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get all of-the-day deal
  static Future<Map<String, dynamic>> getTodayDealsListAll() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/deals/of-the-day"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get product to category list
  static Future<Map<String, dynamic>> getProductToCategoryList(
      id, index, limit) async {
    return client
        .get(Uri.parse(Constants.apiUrl! +
            "/products/category/$id?limit=$limit&page=$index"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get product to sub category list
  static Future<Map<String, dynamic>> getProductToSubCategoryList(
      id, index, limit) async {
    return client
        .get(Uri.parse(Constants.apiUrl! +
            "/products/sub-category/$id?limit=$limit&page=$index"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // product detail
  static Future<Map<String, dynamic>> productDetails(productId) async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/products/detail/$productId"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get all home page data
  static Future<Map<String, dynamic>?> getProdCatDealTopDeal() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/products/home"))
        .then((response) async {
      await Common.setAllData(json.decode(response.body));
      return json.decode(response.body);
    });
  }

  // search product
  static Future<dynamic> getSearchList(status, index, limit) async {
    return client
        .get(Uri.parse(Constants.apiUrl! +
            '/products/search?q=$status&limit=$limit&page=$index'))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get all sub-categories list
  static Future<dynamic> getSubCatList() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + '/sub-categories/list'))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get product rating
  static Future<dynamic> productRating(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + '/ratings/rate'),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  //getSubscriptionListByUser
  static Future<dynamic> getSubscriptionListByUser(index, limit) async {
    return client
        .get(Uri.parse(
            Constants.apiUrl! + "/subscriptions/list?limit=$limit&page=$index"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  //getSubscription deatils
  static Future<dynamic> getSubscriptionDetails(subscriptionId) async {
    return client
        .get(Uri.parse(
            Constants.apiUrl! + "/subscriptions/detail/$subscriptionId"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  //getSubscriptionList orders
  static Future<dynamic> getSubscriptionListOrder(index, limit) async {
    return client
        .get(Uri.parse(Constants.apiUrl! +
            "/subscriptions/order/list?limit=$limit&page=$index"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  //Subscription pause
  static Future<dynamic> getSubscriptionPause(subscriptionId, body) async {
    return client
        .put(
            Uri.parse(Constants.apiUrl! +
                "/subscriptions/update-status-pause/$subscriptionId"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  //Subscription resume
  static Future<dynamic> getSubscriptionResumeAndCancel(
      subscriptionId, isResume) async {
    return client
        .put(Uri.parse(Constants.apiUrl! +
            (isResume
                ? "/subscriptions/update-status-active/$subscriptionId"
                : "/subscriptions/update-status-cancel/$subscriptionId")))
        .then((response) {
      return json.decode(response.body);
    });
  }
}
