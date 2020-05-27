import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/initialize_i18n.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/settings/globalSettings.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> localizedValues = await initializeI18n();
  // print(localizedValues);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String locale = prefs.getString('selectedLanguage') ?? "en";

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  getToken();
  runZoned<Future<Null>>(() async {
    runApp(new MyApp(null, null, null));
  }, onError: (error, stackTrace) async {
    await sentryError.reportError(error, stackTrace);
  });
}

getToken() async {
  Common.getToken().then((onValue) {
    if (onValue != null) {
      checkToken(onValue);
    } else {}
  }).catchError((error) {
    sentryError.reportError(error, null);
  });
}

checkToken(token) async {
  LoginService.checkToken().then((onValue) {
    try {
      if (onValue['response_data']['tokenVerify'] == false) {
        Common.setToken(null);
      } else {
        userInfoMethod();
      }
    } catch (error, stackTrace) {
      sentryError.reportError(error, stackTrace);
    }
  }).catchError((error) {
    sentryError.reportError(error, null);
  });
}

userInfoMethod() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await LoginService.getUserInfo().then((onValue) {
    try {
      prefs.setString('userID', onValue['response_data']['userInfo']['_id']);
    } catch (error, stackTrace) {
      sentryError.reportError(error, stackTrace);
    }
  }).catchError((error) {
    sentryError.reportError(error, null);
  });
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  final List languagesSelection;
  MyApp(this.locale, this.localizedValues, this.languagesSelection);
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var language;
  bool isloading = false;
  LocationData currentLocation;
  Location _location = new Location();
  var addressData;
  Map languagesJson;
  String languageCode;
  List languagesList;
  void initState() {
    getGlobalSettingsData();
    super.initState();
  }

  loadJsonFromAsset(language) async {
    print(language);
    return await rootBundle.loadString(language);
  }

  Map<String, String> convertValueToString(obj) {
    print("obj");
    print(obj);
    Map<String, String> result = {};
    obj.forEach((key, value) {
      result[key] = value.toString();
      print(result);
    });
    return result;
  }

  Future<Map<String, Map<String, String>>> initializeI18nFindJson(json) async {
    print(json);
    Map<String, Map<String, String>> values = {};

    Map<String, String> translation =
        json.decode(await loadJsonFromAsset(json));
    print(translation);
    values[language] = convertValueToString(translation);
    print(values);
    return values;
  }

  getGlobalSettingsData() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    currentLocation = await _location.getLocation();
    Common.getLanguage().then((value) {
      print("lk$value");
      if (value != null && value['languageCode'] != null) {
        LoginService.getLanguageJson(value['languageCode'])
            .then((languageResponse) {
          print(languageResponse);
          if (languageResponse['response_code'] == 200) {
            Common.setLanguage(
                languageResponse['response_data']['defaultCode']);
            Common.setLanguageList(
                languageResponse['response_data']['langCode']);

            if (mounted) {
              setState(() async {
                Map<String, Map<String, String>> localizedValues =
                    await initializeI18nFindJson(
                        languageResponse['response_data']['json']);
                print(languagesJson);
                languageCode = languageResponse['response_data']['defaultCode']
                    ['languageCode'];
                print(languageCode);
                languagesList = languageResponse['response_data']['langCode'];
                print(languagesList);
                languagesJson = localizedValues;
                isloading = false;
              });
            }
          }
        });
      } else {
        LoginService.getLanguageJson("").then((languageResponse) {
          print(languageResponse);
          if (languageResponse['response_code'] == 200) {
            Common.setLanguage(
                languageResponse['response_data']['defaultCode']);
            Common.setLanguageList(
                languageResponse['response_data']['langCode']);
            if (mounted) {
              setState(() async {
                Map<String, Map<String, String>> localizedValues =
                    await initializeI18nFindJson(
                        languageResponse['response_data']['json']);
                languageCode = languageResponse['response_data']['defaultCode']
                    ['languageCode'];
                print(languageCode);
                languagesList = languageResponse['response_data']['langCode'];
                print(languagesList);
                languagesJson = localizedValues;
                print(languagesJson);
                isloading = false;
              });
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return languagesJson == null ||
            languagesList == null ||
            languageCode == null
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.APP_NAME,
            theme: ThemeData(primaryColor: primary, accentColor: primary),
            home: AnimatedScreen(
              locale: language != null ? language : widget.locale,
              localizedValues: widget.localizedValues,
            ))
        : MaterialApp(
            locale: Locale(languageCode),
            localizationsDelegates: [
              MyLocalizationsDelegate(languagesJson),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales:
                languagesList.map((language) => Locale(language, '')),
            debugShowCheckedModeBanner: false,
            title: Constants.APP_NAME,
            theme: ThemeData(primaryColor: primary, accentColor: primary),
            home: Home(
              locale: language != null ? language : widget.locale,
              localizedValues: widget.localizedValues,
            ),
          );
  }
}

class AnimatedScreen extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  AnimatedScreen({Key key, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _AnimatedScreenState createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'lib/assets/splash.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
