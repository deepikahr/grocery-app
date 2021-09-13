import 'package:http/http.dart' show Client;
// import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/intercepter.dart';
// import 'dart:io' show Platform;

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

  // static onChat() async {
  //   if (await canLaunch(url())) {
  //     await launch(url());
  //   } else {
  //     throw 'Could not launch ${url()}';
  //   }
  // }

  // static String url() {
  //   if (Platform.isAndroid) {
  //     return "https://wa.me/${Constants.phone}/?text=${Constants.message}"; // new line
  //   } else {
  //     return "https://api.whatsapp.com/send?phone=${Constants.phone}=${Constants.message}"; // new line
  //   }
  // }
}
