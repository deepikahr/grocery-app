import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/alert-service.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/error-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter/services.dart' show Brightness;

ReportError reportError = new ReportError();

void main() {
  initializeMain(isTest: false);
}

void initializeMain({bool? isTest}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // The following lines are the same as previously explained in "Handling uncaught errors"
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    // To catch errors that happen outside of the Flutter context
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    await FlutterConfig.loadEnvVariables();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    AlertService().checkConnectionMethod();
    if (Constants.stripKey != null && Constants.stripKey!.isNotEmpty) {
      Stripe.publishableKey = Constants.stripKey!;
      await Stripe.instance.applySettings();
    }

    runApp(MainScreen());
    return Future.value(null);
  }, (error, stackTrace) {
    reportError.reportError(error, stackTrace);
  });
  initializeLanguage(isTest: isTest);
}

void initializeLanguage({bool? isTest}) async {
  if (isTest != null && !isTest) {
    configLocalNotification();
  }
  getToken();
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
    reportError.reportError(error, null);
  });
}

void userInfoMethod() async {
  await LoginService.getUserInfo().then((onValue) async {
    await Common.setUserID(onValue['response_data']['_id']);
  }).catchError((error) {
    reportError.reportError(error, null);
  });
}

Future<void> configLocalNotification() async {
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId(Constants.oneSignalKey!);
  await OneSignal.shared.promptUserForPushNotificationPermission();
  var playerId = (await OneSignal.shared.getDeviceState())?.userId;
  if (playerId != null) {
    await Common.setPlayerID(playerId);
    getToken();
  }

  ///test
  // Use FirebaseCrashlytics to throw an error. Use this for
  // confirmation that errors are being correctly reported.
  //sleep(const Duration(seconds: 5));
  //FirebaseCrashlytics.instance.crash();
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  String? locale;
  Map? localizedValues;
  bool isGetJsonLoading = false;
  void initState() {
    super.initState();
    getJson();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void dispose() {
    super.dispose();
  }

  getJson() async {
    setState(() {
      isGetJsonLoading = true;
    });
    await Common.getSelectedLanguage().then((selectedLocale) async {
      String defaultLocale = '';
      locale = selectedLocale ?? defaultLocale;
      await LoginService.getLanguageJson(locale).then((value) async {
        setState(() {
          isGetJsonLoading = false;
        });
        localizedValues = value['response_data']['json'];
        locale = value['response_data']['languageCode'];
        Common.setNoConnection({
          "NO_INTERNET": value['response_data']['json'][locale]["NO_INTERNET"],
          "ONLINE_MSG": value['response_data']['json'][locale]["ONLINE_MSG"],
          "NO_INTERNET_MSG": value['response_data']['json'][locale]
              ["NO_INTERNET_MSG"]
        });
        await Common.setSelectedLanguage(locale!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return isGetJsonLoading
              ? MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: Constants.appName,
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  home: AnimatedScreen())
              : MaterialApp(
                  locale: Locale(locale!),
                  localizationsDelegates: [
                    MyLocalizationsDelegate(localizedValues, [locale]),
                    GlobalWidgetsLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    DefaultCupertinoLocalizations.delegate
                  ],
                  supportedLocales: [Locale(locale!)],
                  debugShowCheckedModeBanner: false,
                  title: Constants.appName,
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  home: Home(locale: locale, localizedValues: localizedValues),
                );
        },
      ),
    );
  }
}

class AnimatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      body: Container(
        color: primary(context),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset('lib/assets/splash.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width),
      ),
    );
  }
}

class DarkThemePreference {
  static const THEME_STATUS = "THEME STATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
