import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

Timer oneSignalTimer;

void main() {
  initializeMain();
}

void initializeMain() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  oneSignalTimer = Timer.periodic(Duration(seconds: 4), (timer) {
    configLocalNotification();
  });
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
      locale = value['response_data']['languageCode'];
      await Common.setSelectedLanguage(locale);
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
      Common.getSelectedLanguage().then((selectedLocale) async {
        Map body = {"language": selectedLocale};
        await LoginService.updateUserInfo(body);
        userInfoMethod();
      });
    }
  }).catchError((error) {
    sentryError.reportError(error, null);
  });
}

void userInfoMethod() async {
  await LoginService.getUserInfo().then((onValue) async {
    await Common.setUserID(onValue['response_data']['_id']);
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
  await OneSignal.shared.init(Constants.oneSignalKey, iOSSettings: settings);
  OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  var status = await OneSignal.shared.getPermissionSubscriptionState();
  String playerId = status.subscriptionStatus.userId;
  if (playerId != null) {
    await Common.setPlayerID(playerId);
    if (oneSignalTimer != null && oneSignalTimer.isActive)
      oneSignalTimer.cancel();
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
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
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
        child: Constants.APP_NAME.contains('Readymade Grocery App')
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
