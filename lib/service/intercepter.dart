import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/common.dart';

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    String languageCode, token;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    try {
      data.headers['Content-Type'] = 'application/json';
      data.headers['language'] = languageCode;
      data.headers['Authorization'] = 'bearer $token';
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async => data;
}
