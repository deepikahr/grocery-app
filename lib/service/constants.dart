import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // app name
  static const APP_NAME = "Readymade Grocery App test";

  // delopy url production
  static String apiUrl = DotEnv().env['API_URL'];

  // local socketUrl
  static final String socketUrl = apiUrl.substring(0, apiUrl.length - 1);

  // ONE_SIGNAL_KEY
  static String oneSignalKey = DotEnv().env['ONE_SIGNAL_KEY'];

  // googleapikey
  static String googleMapApiKey = DotEnv().env['GOOGLE_MAP_API_KEY'];

  // stripe key
  static String stripKey = DotEnv().env['STRIPE_KEY'];

  // image url
  static String imageUrlPath = DotEnv().env['IMAGE_URL_PATH'];

  // dashboard url
  static String baseUrl = DotEnv().env['BASE_URL'];
}
