import 'package:grocery_pro/service/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/service/sentry-service.dart';

SentryError sentryError = new SentryError();

Future<dynamic> getGlobalSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.get(Constants.baseURL + 'setting/currency',
      headers: {'Content-Type': 'application/json'});
  print('Data.............${response.body}');
  prefs.setString('globalSettings', response.body);
  return json.decode(response.body);
}

// get Globlsettings from storage
Future<String> getSavedSettingsData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return Future(() => prefs.getString('globalSettings'));
}
