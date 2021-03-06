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
      print('\nššš REQUEST ššš');
      print('ššš baseUrl: ${data.baseUrl}');
      print('ššš url: ${data.url}');
      print('ššš headers: ${data.headers}');
      printWrapped('ššš body: ${data.body}');
      print('ššš method: ${data.method}');
      print('ššš queryParameters: ${data.params}');
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    var errorData = json.decode(data.body!);
    print('\nššš RESPONSE ššš');
    print('ššš url: ${data.url}');
    print('ššš status code: ${data.statusCode}');
    printWrapped('ššš response: ${data.body}');

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
      return Future.error('Unexpected error š¢');
    } else if (data.statusCode == 401) {
      await Common.deleteToken();
      await Common.deleteUserId();
      return Future.error('Unexpected error š¢');
    } else if (data.statusCode == 500) {
      AlertService().showToast(errorData['message'] ?? 'Unexpected error š¢');
      return Future.error('Unexpected error š¢');
    }
    return data;
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
