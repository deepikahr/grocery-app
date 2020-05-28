import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Location _location = new Location();
  _location.getLocation();
  configLocalNotification();
  runZoned<Future<Null>>(() {
    runApp(MaterialApp(
      home: AnimatedScreen(),
      debugShowCheckedModeBanner: false,
    ));
    return Future.value(null);
  }, onError: (error, stackTrace) {
    sentryError.reportError(error, stackTrace);
  });
  SharedPreferences.getInstance().then((prefs) {
    Map localizedValues;
    String defaultLocale = '';
    String locale = prefs.getString('selectedLanguage') ?? defaultLocale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    FlutterError.onError = (FlutterErrorDetails details) {
      if (isInDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      } else {
        Zone.current.handleUncaughtError(details.exception, details.stack);
      }
    };
    getToken();
    LoginService.getLanguageJson(locale).then((value) {
      print(value);
      localizedValues = value['response_data']['json'];
      if (locale == '') {
        defaultLocale = value['response_data']['defaultCode']['languageCode'];
        locale = defaultLocale;
      }
      prefs.setString('selectedLanguage', locale);
      prefs.setString(
          'alllanguageNames', json.encode(value['response_data']['langName']));
      prefs.setString(
          'alllanguageCodes', json.encode(value['response_data']['langCode']));
      runZoned<Future<Null>>(() {
        runApp(MainScreen(
          locale: locale,
          localizedValues: localizedValues,
        ));
        return Future.value(null);
      }, onError: (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      });
    });
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

Future<void> configLocalNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var settings = {
    OSiOSSettings.autoPrompt: true,
    OSiOSSettings.promptBeforeOpeningPushUrl: true
  };
  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {});
  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
  await OneSignal.shared.init(Constants.ONE_SIGNAL_KEY, iOSSettings: settings);
  OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  var status = await OneSignal.shared.getPermissionSubscriptionState();
  String playerId = status.subscriptionStatus.userId;
  if (playerId == null) {
    configLocalNotification();
  } else {
    prefs.setString("playerId", playerId);
  }
}

class MainScreen extends StatelessWidget {
  final String locale;
  final Map localizedValues;

  MainScreen({
    Key key,
    this.locale,
    this.localizedValues,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: [
        MyLocalizationsDelegate(localizedValues, [locale]),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale(locale)],
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
      theme: ThemeData(primaryColor: primary, accentColor: primary),
      home: Home(
        locale: locale,
        localizedValues: localizedValues,
      ),
    );
  }
}

class AnimatedScreen extends StatelessWidget {
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
