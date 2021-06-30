import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:readymade_grocery_app/service/intercepter.dart';
import 'dart:convert';
import 'constants.dart';

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
