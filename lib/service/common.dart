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

  static Future<bool> setAllData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('allData', json.encode(data));
  }

  static Future<Map<String, dynamic>> getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('allData');
    try {
      return json.decode(info) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setCartData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('cartData', json.encode(data));
  }

  static Future<Map<String, dynamic>> getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('cartData');
    try {
      return json.decode(info) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setAllDataQuary(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('allDataQuary', json.encode(data));
  }

  static Future<Map<String, dynamic>> getAllDataQuary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('allDataQuary');
    try {
      return json.decode(info) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setBanner(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('bannerInfo', json.encode(data));
  }

  static Future<Map<String, dynamic>> getBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('bannerInfo');
    try {
      return json.decode(info) as Map<String, dynamic>;
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setCurrentLocation(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('currentLocation', token);
  }

  static Future<String> getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('currentLocation'));
  }

  static Future<bool> setSelectedLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('selectedLanguage', lang);
  }

  static Future<String> getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('selectedLanguage'));
  }

  static Future<bool> setAllLanguageNames(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('alllanguageNames', json.encode(data));
  }

  static Future getAllLanguageNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('alllanguageNames');
    try {
      return json.decode(info);
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setAllLanguageCodes(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('alllanguageCodes', json.encode(data));
  }

  static Future getAllLanguageCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('alllanguageCodes');
    try {
      return json.decode(info);
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userID', id);
  }

  static Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('userID'));
  }

  static Future<bool> setPlayerID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('playerId', id);
  }

  static Future<String> getPlayerID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('playerId'));
  }

  static Future<bool> setCurrency(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('currency', code);
  }

  static Future<String> getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('currency'));
  }

  // SentryError sentryError = new SentryError();

  static Future<bool> setSavedSettingsData(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('globalSettings', json.encode(data));
  }

  Future<String> getSavedSettingsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('globalSettings'));
  }
}
