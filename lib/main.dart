import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/constants.dart';
import 'package:grocery_pro/service/initialize_i18n.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/settings/globalSettings.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/loader.dart';
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
    runApp(new MyApp(locale, localizedValues, false));
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
      } else {}
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
  final bool languagesSelection;
  MyApp(this.locale, this.localizedValues, this.languagesSelection);
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var language;
  bool isloading = false;
  void initState() {
    if (widget.languagesSelection == false) {
      getGlobalSettingsData();
    }
    super.initState();
  }

  getGlobalSettingsData() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getGlobalSettings().then((onValue) {
      try {
        if (onValue['response_data']['languageCode'] == null) {
          prefs.setString('selectedLanguage', 'en');
          language = prefs.getString("selectedLanguage");
        } else {
          prefs.setString('selectedLanguage',
              '${onValue['response_data']['languageCode']}');
          language = prefs.getString("selectedLanguage");
        }
        if (language != null) {
          if (mounted) {
            setState(() {
              isloading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(language != null ? language : widget.locale),
      localizationsDelegates: [
        MyLocalizationsDelegate(widget.localizedValues),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales:
          Constants.LANGUAGES.map((language) => Locale(language, '')),
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
      theme: ThemeData(primaryColor: primary, accentColor: primary),
      home: isloading
          ? SquareLoader()
          : Home(
              locale: language != null ? language : widget.locale,
              localizedValues: widget.localizedValues,
              languagesSelection: widget.languagesSelection,
            ),
    );
  }
}
