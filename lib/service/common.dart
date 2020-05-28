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

  static Future<String> getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('currentLocation'));
  }
}
