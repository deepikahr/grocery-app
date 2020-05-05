import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geocoder/geocoder.dart';
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
  final bool languagesSelection;
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
  void initState() {
    getGlobalSettingsData();

    getResult();
    super.initState();
  }

  getGlobalSettingsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selectedLanguage') == null) {
      if (mounted) {
        setState(() {
          isloading = true;
        });
      }
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
  }

  getResult() async {
    Common.getCurrentLocation().then((address) async {
      if (address != null) {
        if (mounted) {
          setState(() {
            addressData = address;
          });
        }
      }
      currentLocation = await _location.getLocation();
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      if (mounted) {
        setState(() {
          addressData = first.addressLine;
        });
      }
      Common.setCurrentLocation(addressData);
      return first;
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
      home: isloading || addressData == null
          ? AnimatedScreen(
              locale: language != null ? language : widget.locale,
              localizedValues: widget.localizedValues,
            )
          : Home(
              locale: language != null ? language : widget.locale,
              localizedValues: widget.localizedValues,
              languagesSelection: widget.languagesSelection,
              addressData: addressData,
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
