import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'dart:convert';
import 'constants.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

class LoginService {
  // user login
  static Future signIn(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/users/login"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // forget password
  static Future forgetPassword(email) async {
    Map body = {"email": email};
    return client
        .post(Uri.parse(Constants.apiUrl! + "/users/forgot-password"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // verify otp
  static Future verifyOtp(otp, email) async {
    return client
        .get(Uri.parse(
            Constants.apiUrl! + "/users/verify-otp?email=$email&otp=$otp"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // reset password
  static Future resetPassword(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/users/reset-password"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // change password
  static Future changePassword(body) async {
    return client
        .post(Uri.parse(Constants.apiUrl! + "/users/change-password"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get user info
  static Future getUserInfo() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/users/me"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // image delete
  static Future imagedelete() async {
    return client
        .delete(Uri.parse(Constants.apiUrl! + "/users/delete/image"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // user data update
  static Future updateUserInfo(body) async {
    return client
        .put(Uri.parse(Constants.apiUrl! + "/users/update/profile"),
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get about us data
  static Future businessInfo() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/business/detail"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get about us data
  static Future aboutUs() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + "/pages/about-us"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get about us data
  static Future tandCandPandPMethod(endPoint) async {
    return client.get(Uri.parse(Constants.apiUrl! + endPoint)).then((response) {
      return json.decode(response.body);
    });
  }

  // get json data
  static Future getLanguageJson(languageCode) async {
    return client
        .get(
            Uri.parse(Constants.apiUrl! + "/languages/user?code=$languageCode"))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get location info
  static Future getLocationformation() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + '/settings/details'))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // verify mail send api
  static Future<dynamic> verificationMailSendApi(email) async {
    return client
        .get(Uri.parse(
            Constants.apiUrl! + '/users/resend-verify-email?email=$email'))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get languages list api
  static Future<dynamic> getLanguagesList() async {
    return client
        .get(Uri.parse(Constants.apiUrl! + '/languages/list'))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get all wallet history
  static Future<Map<String, dynamic>> getWalletsHistory(index, limit) async {
    return client
        .get(Uri.parse(
            Constants.apiUrl! + "/wallets/history?limit=$limit&page=$index"))
        .then((response) {
      return json.decode(response.body);
    });
  }
}
