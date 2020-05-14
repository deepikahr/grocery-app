import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/main.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/drawer/address.dart';
import 'package:readymadeGroceryApp/screens/orders/orders.dart';
import 'package:readymadeGroceryApp/screens/tab/editprofile.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/initialize_i18n.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class Profile extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  Profile({Key key, this.locale, this.localizedValues}) : super(key: key);

  &#64;override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userInfo;
  bool isProfile = true, isGetTokenLoading = false;
  List orderList = List();
  String token, selectedLanguages, userID;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String newValue;
  List<String> languages = [
    'English',
    'French',
    'Chinese',
    'Arbic',
    'Japanese',
    'Russian',
    'Italian',
    'Spanish',
    'Portuguese'
  ];
  Map<String, Map<String, String>> localizedValues;
  var userData;

  &#64;override
  void initState() {
    getToken();
    super.initState();
  }

  &#64;override
  void dispose() {
    super.dispose();
  }

  getToken() async {
    if (mounted) {
      setState(() {
        isGetTokenLoading = true;
      });
    }
    await Common.getToken().then((onValue) {
      try {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              token = onValue;
              userInfoMethod();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  userInfoMethod() async {
    await LoginService.getUserInfo().then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;

            userInfo = onValue['response_data']['userInfo'];

            userID = userInfo['_id'];
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;

            userInfo = null;
            userID = null;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetTokenLoading = false;

          userInfo = null;
          userID = null;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  selectLanguagesMethod() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(
                  new Radius.circular(24.0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                      padding: EdgeInsets.only(bottom: 25),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          languages.length == null ? 0 : languages.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GFButton(
                          onPressed: () async {
                            await initializeI18n().then((value) async {
                              localizedValues = value;
                              if (mounted) {
                                setState(() {
                                  newValue = languages[i];
                                });
                              }
                              if (newValue == 'English') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'en');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("en", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              } else if (newValue == 'Chinese') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'zh');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("zh", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              } else if (newValue == 'Arbic') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'ar');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("ar", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              } else if (newValue == 'Japanese') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'ja');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("ja", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              } else if (newValue == 'Russian') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'ru');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("ru", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              } else if (newValue == 'Italian') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'it');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("it", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              } else if (newValue == 'Spanish') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'es');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("es", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              } else if (newValue == 'Portuguese') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'pt');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("pt", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              } else {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('selectedLanguage', 'fr');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyApp("fr", localizedValues, true),
                                    ),
                                    (Route<dynamic> route) => false);
                              }
                            });
                          },
                          type: GFButtonType.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                languages[i],
                                style: hintSfboldBig(),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        });
  }

  &#64;override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  elevation: 0,
                  title: Text(
                    MyLocalizations.of(context).profile,
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: primary,
                  automaticallyImplyLeading: false,
                ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          setState(() {
            getTok...</Widget></dynamic></dynamic></dynamic></dynamic></dynamic></dynamic></dynamic></dynamic></dynamic></Widget></String></Profile>