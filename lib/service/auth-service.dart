import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'common.dart';

class LoginService {
  static final Client client = Client();
  // register user
  static Future<Map<String, dynamic>> signUp(body) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "users/register",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  // user login
  static Future<Map<String, dynamic>> signIn(body) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "users/login",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
        });

    return json.decode(response.body);
  }

  // verify email
  static Future<Map<String, dynamic>> verifyEmail(body) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "users/verify/email",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  // verify otp
  static Future<Map<String, dynamic>> verifyOtp(body, token) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "users/verify/OTP",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  // reset password
  static Future<Map<String, dynamic>> resetPassword(body, token) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(
        Constants.baseURL + "users/reset-password",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  // get user info
  static Future<Map<String, dynamic>> getUserInfo() async {
    String token, languageCode;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.get(Constants.baseURL + "users/me", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  // image upload
  static Future<Map<String, dynamic>> imageUpload(body) async {
    String token, languageCode;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(
        Constants.baseURL + "utils/upload/profile/picture",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  // image delete
  static Future<Map<String, dynamic>> imagedelete(key) async {
    String token, languageCode;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .delete(Constants.baseURL + "utils/imgaeKit/delete/$key", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  // user data update
  static Future<Map<String, dynamic>> updateUserInfo(body) async {
    String token, languageCode;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.patch(
        Constants.baseURL + "users/update/profile",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  // check token
  static Future<Map<String, dynamic>> checkToken() async {
    String token, languageCode;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.baseURL + "users/verify/token", headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getBanner() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.get(Constants.baseURL + "banner", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    await Common.setBanner(json.decode(response.body));
    return json.decode(response.body);
  }

  // notification list
  static Future<Map<String, dynamic>> getOrderHistory(orderId) async {
    String token, languageCode;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.baseURL + "orders/info/$orderId", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> restoInfo() async {
    String token, languageCode;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "users/admin/infomation", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> aboutUs() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client
        .get(Constants.baseURL + "business/business/about/us", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getLanguageJson(languageCode) async {
    final response = await client.get(
        Constants.baseURL +
            "language/user/info?req_from=mobAppJson&language_code=$languageCode",
        headers: {
          'Content-Type': 'application/json',
        });
    return json.decode(response.body);
  }

  static Future<dynamic> getGlobalSettings() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.baseURL + 'setting/user/App', headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });
    await Common.setSavedSettingsData(response.body);
    return json.decode(response.body);
  }

  static Future<dynamic> setLanguageCodeToProfile() async {
    String languageCode, token;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.baseURL + 'users/language/set', headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
      'Authorization': 'bearer $token',
    });
    return json.decode(response.body);
  }
}
