import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class LoginService {
  // register user
  static Future<Map<String, dynamic>> signUp(body) async {
    final response = await client.post(Constants.apiUrl + "users/register",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // user login
  static Future<Map<String, dynamic>> signIn(body) async {
    final response = await client.post(Constants.apiUrl + "users/login",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // verify email
  static Future<Map<String, dynamic>> forgetPassword(email) async {
    Map body = {"email": email};
    final response = await client.post(
        Constants.apiUrl + "users/forgot-password",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // verify otp
  static Future<Map<String, dynamic>> verifyOtp(otp, email) async {
    final response = await client
        .get(Constants.apiUrl + "users/verify-otp?email=$email&otp=$otp");
    return json.decode(response.body);
  }

  // reset password
  static Future<Map<String, dynamic>> resetPassword(body) async {
    final response = await client.post(
        Constants.apiUrl + "users/reset-password",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // change password
  static Future<Map<String, dynamic>> changePassword(body) async {
    final response = await client.post(
        Constants.apiUrl + "users/change-password",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // get user info
  static Future<Map<String, dynamic>> getUserInfo() async {
    final response = await client.get(Constants.apiUrl + "users/me");
    return json.decode(response.body);
  }

  // image delete
  static Future<Map<String, dynamic>> imagedelete() async {
    final response =
        await client.delete(Constants.apiUrl + "users/delete/image");
    return json.decode(response.body);
  }

  // user data update
  static Future<Map<String, dynamic>> updateUserInfo(body) async {
    final response = await client.put(Constants.apiUrl + "users/update/profile",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // get about us data
  static Future<Map<String, dynamic>> aboutUs() async {
    final response = await client.get(Constants.apiUrl + "business/detail");
    return json.decode(response.body);
  }

  // get json data
  static Future<Map<String, dynamic>> getLanguageJson(languageCode) async {
    final response = await client
        .get(Constants.apiUrl + "languages/user?code=$languageCode");
    return json.decode(response.body);
  }

  // get location info
  static Future<Map<String, dynamic>> getLocationformation() async {
    final response = await client.get(Constants.apiUrl + 'settings/details');
    return json.decode(response.body);
  }

  // verify mail send api
  static Future<dynamic> verificationMailSendApi(email) async {
    final response = await client
        .get(Constants.apiUrl + 'users/resend-verify-email?email=$email');
    return json.decode(response.body);
  }

  // get languages list api
  static Future<dynamic> getLanguagesList() async {
    final response = await client.get(Constants.apiUrl + 'languages/list');
    return json.decode(response.body);
  }
}
