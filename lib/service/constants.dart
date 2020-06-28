import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // app name
  static const APP_NAME = "Readymade Grocery App test";

  // delopy url production
  static String baseURL = DotEnv().env['BASE_URL'];

  // local socketUrl
  static final String socketUrl = baseURL.substring(0, baseURL.length - 1);

  // ONE_SIGNAL_KEY
  static String oneSignalKey = DotEnv().env['ONE_SIGNAL_KEY'];

  // googleapikey
  static String googleMapApiKey = DotEnv().env['GOOGLE_MAP_API_KEY'];

  // stripe key
  static String stripKey = DotEnv().env['STRIPE_KEY'];

  // image url
  static String imageUrlPath = DotEnv().env['IMAGE_URL_PATH'];
}
