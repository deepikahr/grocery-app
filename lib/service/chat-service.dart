import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

class ChatService {
  static Future<Map<String, dynamic>> chatDataMethod(
      pageNumber, chatDataLimit) async {
    return client
        .get(Uri.parse(Constants.apiUrl! +
            "/chats/list?page=$pageNumber&limit=$chatDataLimit"))
        .then((response) {
      return json.decode(response.body);
    });
  }
}
