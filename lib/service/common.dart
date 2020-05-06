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

  static Future<bool> setBanner(Map<String, dynamic> cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('bannerInfo', json.encode(cartInfo));
  }

  static Future<bool> setAllData(Map<String, dynamic> cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('allData', json.encode(cartInfo));
  }

  static Future<bool> setAllDataQuary(Map<String, dynamic> cartInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('allDataQuary', json.encode(cartInfo));
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

  static Future<Map<String, dynamic>> getBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('bannerInfo');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<Map<String, dynamic>> getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('allData');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<Map<String, dynamic>> getAllDataQuary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartStorage = prefs.getString('allDataQuary');
    try {
      return json.decode(cartStorage) as Map<String, dynamic>;
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
}
