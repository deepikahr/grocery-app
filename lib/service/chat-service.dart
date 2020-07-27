import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'dart:convert';
import 'constants.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class ChatService {
  static Future<Map<String, dynamic>> chatDataMethod(
      pageNumber, chatDataLimit) async {
    final response = await client.get(
        Constants.apiUrl + "chats/list?page=$pageNumber&limit=$chatDataLimit");
    return json.decode(response.body);
  }
}
