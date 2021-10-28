import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  // save token on storage
  static Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  // retrive token from storage
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('token'));
  }

  static Future<bool> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.remove('token'));
  }

  static Future<bool> setAllData(Map<String, dynamic>? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('allData', json.encode(data));
  }

  static Future<Map<String, dynamic>?> getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? info = prefs.getString('allData');
    try {
      return json.decode(info!) as Map<String, dynamic>?;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setCartData(Map<String, dynamic>? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('cartData', json.encode(data));
  }

  static Future<Map<String, dynamic>?> getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? info = prefs.getString('cartData');
    try {
      return json.decode(info!) as Map<String, dynamic>?;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setCartDataCount(int data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt('cartDataCount', data);
  }

  static Future<int?> getCartDataCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getInt('cartDataCount'));
  }

  static Future<bool> setBanner(Map<String, dynamic>? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('bannerInfo', json.encode(data));
  }

  static Future<Map<String, dynamic>?> getBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? info = prefs.getString('bannerInfo');
    try {
      return json.decode(info!) as Map<String, dynamic>?;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setCurrentLocation(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('currentLocation', lang);
  }

  static Future<String?> getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('currentLocation'));
  }

  static Future<bool> setSelectedLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('selectedLanguage', lang);
  }

  static Future<String?> getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('selectedLanguage'));
  }

  static Future<bool> setUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userID', id);
  }

  static Future<bool> deleteUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.remove('userID'));
  }

  static Future<String?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('userID'));
  }

  static Future<bool> setPlayerID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('playerId', id);
  }

  static Future<String?> getPlayerID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('playerId'));
  }

  static Future<bool> setCurrency(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('currency', code);
  }

  static Future<String> getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('currency')!);
  }

  static Future<bool> setCountryInfo(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('countryInfo', data);
  }

  static Future<String?> getCountryInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString("countryInfo"));
  }

  static Future<bool> setNoConnection(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('connection', json.encode(data));
  }

  static Future<Map<String, dynamic>?> getNoConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? info = prefs.getString('connection');
    try {
      return json.decode(info!) as Map<String, dynamic>?;
    } catch (err) {
      return Future(() => null);
    }
  }

  // save setSplash on storage
  static Future<bool> setSplash(bool location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('setSplash', location);
  }

  // get setSplash from storage
  static Future<bool?> getSplash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getBool('setSplash'));
  }

  // save setTheme on storage
  static Future<bool> setTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('setTheme', isDark);
  }

  // get setTheme from storage
  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getBool('setTheme')!);
  }

  static Future<bool> setSubcriptionData(Map<String, dynamic>? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('subscriptionData', json.encode(data));
  }

  static Future<Map<String, dynamic>?> getSubcriptionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? info = prefs.getString('subscriptionData');
    try {
      return json.decode(info!) as Map<String, dynamic>?;
    } catch (err) {
      return Future(() => null);
    }
  }
}
