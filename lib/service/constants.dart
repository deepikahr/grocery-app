import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class Constants {
  // app name
  static String appName = 'Readymade Grocery App';

  // delopy url production
  static String apiUrl = DotEnv().env['API_URL'];

  // ONE_SIGNAL_KEY
  static String oneSignalKey = DotEnv().env['ONE_SIGNAL_KEY'];

  // googleapikey
  static String googleMapApiKey = Platform.isIOS
      ? DotEnv().env['IOS_GOOGLE_MAP_API_KEY']
      : DotEnv().env['ANDROID_GOOGLE_MAP_API_KEY'];

  // stripe key
  static String stripKey = DotEnv().env['STRIPE_KEY'];

  // image url
  static String imageUrlPath = DotEnv().env['IMAGE_URL_PATH'];

  // dashboard url
  static String baseUrl = DotEnv().env['BASE_URL'];

  // PREDEFINED
  static String predefined = DotEnv().env['PREDEFINED'] ?? "false";
}
