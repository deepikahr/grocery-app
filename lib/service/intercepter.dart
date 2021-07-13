import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/alert-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String? languageCode, token;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? '';
    });
    await Common.getToken().then((onValue) {
      token = onValue ?? '';
    });
    try {
      data.headers['Content-Type'] = 'application/json';
      data.headers['language'] = languageCode!;
      data.headers['Authorization'] = 'bearer $token';
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    var errorData = json.decode(data.body!);
    if (data.statusCode == 400) {
      var msg = '';
      for (int? i = 0, l = errorData['errors'].length; i! < l!; i++) {
        if (l != i + 1) {
          msg += errorData['errors'][i] + "\n";
        } else {
          msg += errorData['errors'][i];
        }
      }
      AlertService().showToast(msg);
      return Future.error('Unexpected error 😢');
    } else if (data.statusCode == 401) {
      await Common.deleteToken();
      await Common.deleteUserId();
      return Future.error('Unexpected error 😢');
    }
    return data;
  }
}
