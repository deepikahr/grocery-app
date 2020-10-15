import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';

SentryError sentryError = new SentryError();
Timer oneSignalTimer;

void main() {
  initializeMain(isTest: false);
}

void initializeMain({bool isTest}) async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  // if (isTest != null && !isTest) {
  runZoned<Future>(() {
    runApp(MaterialApp(
      home: AnimatedScreen(),
      debugShowCheckedModeBanner: false,
    ));
    return Future.value(null);
  }, onError: (error, stackTrace) {
    sentryError.reportError(error, stackTrace);
  });
  // }
  initializeLanguage(isTest: isTest);
}

void initializeLanguage({bool isTest}) async {
  if (isTest != null && !isTest) {
    oneSignalTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      configLocalNotification();
    });
    configLocalNotification();
  }
  await Common.getSelectedLanguage().then((selectedLocale) async {
    Map localizedValues;
    String defaultLocale = '';
    String locale = selectedLocale ?? defaultLocale;
    await LoginService.getLanguageJson(locale).then((value) async {
      localizedValues = value['response_data']['json'];
      locale = value['response_data']['languageCode'];
      await Common.setSelectedLanguage(locale);
      runZoned<Future>(() {
        runApp(MainScreen(
          isTest: isTest,
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
      Common.getPlayerID().then((palyerId) {
        Common.getSelectedLanguage().then((selectedLocale) async {
          Map body = {"language": selectedLocale, "playerId": palyerId};
          await LoginService.updateUserInfo(body);
          userInfoMethod();
        });
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
    getToken();
    if (oneSignalTimer != null && oneSignalTimer.isActive)
      oneSignalTimer.cancel();
  }
}

class MainScreen extends StatelessWidget {
  final String locale;
  final Map localizedValues;
  final bool isTest;

  MainScreen({Key key, this.locale, this.localizedValues, this.isTest});

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
      title: Constants.appName,
      theme: ThemeData(primaryColor: primary, accentColor: primary),
      home: Home(
        isTest: isTest,
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
