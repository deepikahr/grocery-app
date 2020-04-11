import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
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

  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<Null>>(() async {
    runApp(new MyApp());
  }, onError: (error, stackTrace) async {
    await sentryError.reportError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  // final Map<String, Map<String, String>> localizedValues;
  // final String locale;
  // MyApp(this.locale, this.localizedValues);
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int responseCode;
  bool isGetTokenLoading = false;

  @override
  void initState() {
    super.initState();

    getToken();
    getData();
  }

  var selectedLanguage;
  LocationData currentLocation;
  var addressData;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        selectedLanguage = prefs.getString('selectedLanguage');
      });
    }
  }

  getToken() async {
    if (mounted)
      setState(() {
        isGetTokenLoading = true;
      });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        checkToken(onValue);
      } else {
        if (mounted)
          setState(() {
            isGetTokenLoading = false;
          });
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  checkToken(token) async {
    await LoginService.checkToken().then((onValue) {
      try {
        if (onValue['response_data']['tokenVerify'] == false) {
          Common.setToken(null).then((onValue) {
            if (mounted)
              setState(() {
                isGetTokenLoading = false;
              });
          }).catchError((error) {
            sentryError.reportError(error, null);
          });
        } else {}
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark
//      statusBarColor: Colors.pink, // status bar color
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Readymade Grocery App',
      theme: ThemeData(
        primaryColor: primary,
        accentColor: primary
      ),
      home: Home(),
    );
  }
}
