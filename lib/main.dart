import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:getflutter/getflutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';

SentryError sentryError = new SentryError();

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  Common.getSelectedLanguage().then((selectedLocale) {
    Map localizedValues;
    String defaultLocale = '';
    String locale = selectedLocale ?? defaultLocale;
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
    LoginService.getLanguageJson(locale).then((value) async {
      localizedValues = value['response_data']['json'];
      if (locale == '') {
        defaultLocale = value['response_data']['defaultCode']['languageCode'];
        locale = defaultLocale;
      }
      await Common.setSelectedLanguage(locale);
      await Common.setAllLanguageNames(value['response_data']['langName']);
      await Common.setAllLanguageCodes(value['response_data']['langCode']);
      getToken();
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

void getToken() async {
  await Common.getToken().then((onValue) async {
    if (onValue != null) {
      await LoginService.setLanguageCodeToProfile();
      checkToken(onValue);
    } else {}
  }).catchError((error) {
    sentryError.reportError(error, null);
  });
}

void checkToken(token) async {
  LoginService.checkToken().then((onValue) async {
    try {
      if (onValue['response_data']['tokenVerify'] == false) {
        await Common.setToken(null);
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

void userInfoMethod() async {
  await LoginService.getUserInfo().then((onValue) async {
    try {
      await Common.setUserID(onValue['response_data']['userInfo']['_id']);
    } catch (error, stackTrace) {
      sentryError.reportError(error, stackTrace);
    }
  }).catchError((error) {
    sentryError.reportError(error, null);
  });
}

Future<void> configLocalNotification() async {
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
    await Common.setPlayerID(playerId);
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
        MyLocalizationsDelegate(localizedValues),
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
        color: primary,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Constants.APP_NAME.contains('Readymade')
            ? Image.asset(
                'lib/assets/splash.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              )
            : GFLoader(
                type: GFLoaderType.ios,
                size: 40,
              ),
      ),
    );
  }
}
