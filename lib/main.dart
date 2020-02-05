// import 'package:flutter/material.dart';
// import 'package:grocery_pro/screens/home.dart';
// import 'package:grocery_pro/verification/verification.dart';
// import 'package:grocery_pro/auth/login.dart';
// import 'package:grocery_pro/auth/signup.dart';
// import 'package:flutter/services.dart';
// import 'package:grocery_pro/style/style.dart';
// import 'service/common.dart';
// import 'service/auth-service.dart';
// import 'service/sentry-service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'screens/welcome/splashscreen.dart';
// import 'screens/welcome/welcome.dart';
// import 'initialize_i18n.dart' show initializeI18n;
// import 'localizations.dart' show MyLocalizationsDelegate;

// // // // SentryError sentryError = new SentryError();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Map<String, Map<String, String>> localizedValues = await initializeI18n();
//   String _locale = 'en';
//   // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
// // //     statusBarColor: Colors.transparent, //top bar color
// // //     statusBarIconBrightness: Brightness.light, //top bar icons
//   // ));
// }

// class MyApp extends StatefulWidget {
//   @override
//   // final Map<String, Map<String, String>> localizedValues;
//   // var locale;
//   // MyApp(this.locale, this.localizedValues);

//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int responseCode = 200;
//   // bool isGetTokenLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // print('this is the step one');
//     // getToken();
//     // getData();
//   }

//   // var selectedLanguage;

//   // getData() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   if (mounted) {
//   //     setState(() {
//   //       selectedLanguage = prefs.getString('selectedLanguage');
//   //     });
//   //   }
//   // }

//   // getToken() async {
//   //   await Common.getToken().then((onValue) {
//   //     if (mounted) {
//   //       setState(() {
//   //         isGetTokenLoading = true;
//   //       });
//   //     }
//   //     print(
//   //         'This is the token Value.......................................................................');
//   //     print(onValue);
//   //     checkToken(onValue);
//   //   }).catchError((error) {
//   //     print('Error at GetToken @main.dart');
//   //     // sentryError.reportError(error, null);
//   //   });
//   // }

//   // checkToken(token) async {
//   //   if (token != null) {
//   //     if (mounted) {
//   //       setState(() {
//   //         isGetTokenLoading = true;
//   //       });
//   //     }
//   //     await LoginService.checkToken().then((onValue) {
//   //       try {
//   //         if (mounted) {
//   //           setState(() {
//   //             responseCode = onValue['response_code'];
//   //             isGetTokenLoading = false;
//   //           });
//   //         }
//   //       } catch (error) {
//   //         print('Error at checkToken stackToken @main.dart');
//   //         // sentryError.reportError(error, stackTrace);
//   //       }
//   //     }).catchError((error) {
//   //       print('Error at checkToken @main.dart');

//   //       // sentryError.reportError(error, null);
//   //     });
//   //   } else {
//   //     if (mounted) {
//   //       setState(() {
//   //         responseCode = 0;
//   //         isGetTokenLoading = false;
//   //       });
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // locale:
//       //     Locale(selectedLanguage == null ? widget.locale : selectedLanguage),
//       // localizationsDelegates: [
//       //   MyLocalizationsDelegate(widget.localizedValues),
//       // ],
//       // debugShowCheckedModeBanner: false,
//       title: 'Grocery Pro',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: WelcomePage(),
//       // localizedValues: widget.localizedValues,
//       // locale: widget.locale,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:grocery_pro/screens/home.dart';
import 'package:grocery_pro/verification/verification.dart';
import 'screens/welcome/welcome.dart';
import 'auth/login.dart';
import 'service/auth-service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}
