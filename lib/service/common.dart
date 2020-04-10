import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Common {
  // save token on storage
  static Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  // retrive token from storage
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('token'));
  }

  // save token on storage
  static Future<bool> setFirbaseToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('firebaseToken', token);
  }

  // retrive token from storage
  static Future<String> getFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('firebaseToken'));
  }

  static Future<bool> setCart(Map<String, dynamic> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('cartItems', json.encode(cart));
  }

  static Future<bool> setProductList(Map<String, dynamic> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('productdsList', json.encode(cart));
  }

  static Future<bool> setCatagrytList(Map<String, dynamic> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('catagrysList', json.encode(cart));
  }

  // get cart items from storage
  static Future<Map<String, dynamic>> getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('cartItems');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<Map<String, dynamic>> getProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('productdsList');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<Map<String, dynamic>> getCatagrysList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('catagrysList');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  // remove cart items from storage
  static Future<bool> removeCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('cartItems');
  }

  // upadate cart info on storage
  static Future<bool> setCartInfo(Map<String, dynamic> cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('cartInfo', json.encode(cartInfo));
  }

  static Future<bool> setCurrentLocation(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('currentLocation', token);
  }

  static Future<bool> setFavList(Map<String, dynamic> cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('favList', json.encode(cartInfo));
  }

  static Future<bool> setAddressList(Map<String, dynamic> cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('addressList', json.encode(cartInfo));
  }

  static Future<bool> setCardInfo(Map<String, dynamic> cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('cardInfo', json.encode(cartInfo));
  }

  static Future<bool> setUserInfo(Map<String, dynamic> cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userInfo', json.encode(cartInfo));
  }

  static Future<bool> setSearchList(List cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('searchList', json.encode(cartInfo));
  }

  static Future<Map<String, dynamic>> getAddressList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('addressList');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<List> getSearchList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('searchList');
    try {
      return json.decode(cartStorage) as List;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<Map<String, dynamic>> getCardInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('cardInfo');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('userInfo');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<Map<String, dynamic>> getFavList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('favList');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<String> getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('currentLocation'));
  }

  // get cart info from storage
  static Future<Map<String, dynamic>> getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('cartInfo');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  // save position info on storage
  static Future<bool> savePositionInfo(Map<String, dynamic> position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('position', json.encode(position));
  }

  // get position info on storage
  static Future<Map<String, dynamic>> getPositionInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String position = prefs.getString('position');
    try {
      return json.decode(position) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }
}
