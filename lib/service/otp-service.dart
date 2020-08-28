import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class OtpService {
  // register user
  static Future signUp(body) async {
    return client
        .post(Constants.apiUrl + "/users/register-phone", body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

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
  static Future verifyOtp(body) async {
    return client
        .post(Constants.apiUrl + "/users/send-otp-phone")
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
}
