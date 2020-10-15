import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class LoginService {
  // register user
  // static Future signUp(body) async {
  //   return client
  //       .post(Constants.apiUrl + "/users/register", body: json.encode(body))
  //       .then((response) {
  //     return json.decode(response.body);
  //   });
  // }

  // user login
  static Future signIn(body) async {
    return client
        .post(Constants.apiUrl + "/users/login", body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // forget password
  static Future forgetPassword(email) async {
    Map body = {"email": email};
    return client
        .post(Constants.apiUrl + "/users/forgot-password",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // verify otp
  static Future verifyOtp(otp, email) async {
    return client
        .get(Constants.apiUrl + "/users/verify-otp?email=$email&otp=$otp")
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future facebookLogin(accessToken, {email, mobileNumber}) async {
    return Client()
        .get(Constants.apiUrl + "/users/fb-login?accessToken=$accessToken")
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future facebookLoginMobile(
      {accessToken,countryCode, countryName, mobileNumber}) async {
    return Client()
        .get(Constants.apiUrl +
            "/users/fb-login?accessToken=$accessToken&countryCode=$countryCode&countryName=$countryName&mobileNumber=$mobileNumber")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // reset password
  static Future resetPassword(body) async {
    return client
        .post(Constants.apiUrl + "/users/reset-password",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // change password
  static Future changePassword(body) async {
    return client
        .post(Constants.apiUrl + "/users/change-password",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get user info
  static Future getUserInfo() async {
    return client.get(Constants.apiUrl + "/users/me").then((response) {
      return json.decode(response.body);
    });
  }

  // image delete
  static Future imagedelete() async {
    return client
        .delete(Constants.apiUrl + "/users/delete/image")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // user data update
  static Future updateUserInfo(body) async {
    return client
        .put(Constants.apiUrl + "/users/update/profile",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get about us data
  static Future businessInfo() async {
    return client.get(Constants.apiUrl + "/business/detail").then((response) {
      return json.decode(response.body);
    });
  }

  // get about us data
  static Future aboutUs() async {
    return client.get(Constants.apiUrl + "/pages/about-us").then((response) {
      return json.decode(response.body);
    });
  }

  // get about us data
  static Future tandCandPandPMethod(endPoint) async {
    return client.get(Constants.apiUrl + endPoint).then((response) {
      return json.decode(response.body);
    });
  }

  // get json data
  static Future getLanguageJson(languageCode) async {
    return client
        .get(Constants.apiUrl + "/languages/user?code=$languageCode")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get location info
  static Future getLocationformation() async {
    return client.get(Constants.apiUrl + '/settings/details').then((response) {
      return json.decode(response.body);
    });
  }

  // verify mail send api
  static Future<dynamic> verificationMailSendApi(email) async {
    return client
        .get(Constants.apiUrl + '/users/resend-verify-email?email=$email')
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get languages list api
  static Future<dynamic> getLanguagesList() async {
    return client.get(Constants.apiUrl + '/languages/list').then((response) {
      return json.decode(response.body);
    });
  }

  // get all wallet history
  static Future<Map<String, dynamic>> getWalletsHistory(index, limit) async {
    return client
        .get(Constants.apiUrl + "/wallets/history?limit=$limit&page=$index")
        .then((response) {
      return json.decode(response.body);
    });
  }
}
