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
  static Future<Map<String, dynamic>> verifyEmail(email) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.get(
        Constants.baseURL + "users/resend-verify-email?email=$email",
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
        });
    print("users/resend-verify-email?email=$email");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  // verify otp
  static Future<Map<String, dynamic>> verifyOtp(body, token) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "users/verify/otp",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    print("users/verify/OTP");
    print(json.decode(response.body));
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
    print("users/reset-password");
    print(json.decode(response.body));
    return json.decode(response.body);
  } // changePassword

  static Future<Map<String, dynamic>> changePassword(body) async {
    String token, languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(
        Constants.baseURL + "users/change-password",
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

  // image delete
  static Future<Map<String, dynamic>> imagedelete() async {
    String token, languageCode;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.delete(Constants.baseURL + "users/delete/image", headers: {
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
    final response = await client.put(
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
    print("orders/info/$orderId");
    print(json.decode(response.body));
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
    print("users/admin/infomation");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> aboutUs() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.baseURL + "business/detail", headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
    });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getLanguageJson(languageCode) async {
    final response = await client
        .get(Constants.baseURL + "languages/user?code=$languageCode", headers: {
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

  static Future<Map<String, dynamic>> getLocationformation() async {
    String token, languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.baseURL + 'delivery/tax/settings/details', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode
    });
    return json.decode(response.body);
  }

  static Future<dynamic> verificationMailSendApi(body) async {
    String languageCode, token;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.put(Constants.baseURL + 'users/verify/link',
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
          'Authorization': 'bearer $token',
        });
    print("users/verify/link");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<dynamic> orderCancle(body) async {
    String languageCode, token;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.put(
        Constants.baseURL + 'orders/cancelled/by-user',
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
          'Authorization': 'bearer $token',
        });
    print("orders/cancelled/by-user");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<dynamic> getLanguagesList() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.get(Constants.baseURL + 'languages/list',
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode
        });

    return json.decode(response.body);
  }
}
