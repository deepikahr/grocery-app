import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class OtpService {
  // register user
  static Future signUpWithNumber(body) async {
    return client
        .post(Constants.apiUrl + "/users/register-phone",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // user login
  static Future signInWithNumber(body) async {
    return client
        .post(Constants.apiUrl + "/users/login-phone", body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // forget password
  static Future forgetPasswordWithNumber(email) async {
    Map body = {"email": email};
    return client
        .post(Constants.apiUrl + "/users/forgot-password",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // verify otp
  static Future verifyOtpWithNumber(body) async {
    return client
        .post(Constants.apiUrl + "/users/verify-otp/number",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future resendOtpWithNumber(mobileNumber) async {
    Map body = {"mobileNumber": mobileNumber.toString()};
    return client
        .post(Constants.apiUrl + "/users/send-otp-phone",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // reset password
  static Future resetPasswordWithNumber(body) async {
    return client
        .post(Constants.apiUrl + "/users/reset-password-number",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }
}
