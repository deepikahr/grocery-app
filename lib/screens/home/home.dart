import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/tab/mycart.dart';
import 'package:grocery_pro/screens/tab/profile.dart';
import 'package:grocery_pro/screens/tab/saveditems.dart';
import 'package:grocery_pro/screens/tab/store.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/settings/globalSettings.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class Home extends StatefulWidget {
  final int currentIndex;
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  Home({Key key, this.currentIndex, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;
  bool isGetTokenLoading = true;
  int currentIndex = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    getGlobalSettingsData();
    getToken();
    configLocalNotification();
    if (widget.currentIndex != null) {
      if (mounted) {
        setState(() {
          currentIndex = widget.currentIndex;
        });
      }
    }
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getGlobalSettingsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    getGlobalSettings().then((onValue) {
      print(onValue['response_data']);
      try {
        if (onValue['response_data']['currency'] == null &&
            onValue['response_data']['currency'][0]['currencySign'] == null) {
          prefs.setString('currency', 'Rs');
        } else {
          prefs.setString('currency',
              '${onValue['response_data']['currency'][0]['currencySign']}');
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getToken() async {
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        firebaseToken();
      } else {}
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  firebaseToken() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        if (message['notification']['title'] != "Registration confirmation") {
          showNotification(message['notification']);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    _firebaseMessaging.getToken().then((String token) async {
      print(token);
      assert(token != null);
      setTokenData(token);
      await Common.setFirbaseToken(token);
      await Common.getFirebaseToken().then((onValue) {
        print(onValue);
      });
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.ionicfirebaseapp.groceryapp'
          : 'com.ionicfirebaseapp.groceryapp',
      'Grocery Pro',
      'Grocery Pro',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  setTokenData(token) async {
    print(token);
    await LoginService.setDeviceToken(token).then((onValue) {
      print(onValue);
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GFTabBarView(
        controller: tabController,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Store(),
          ),
          Container(
            color: Colors.white,
            child: SavedItems(),
          ),
          Container(
            color: Colors.white,
            child: MyCart(),
          ),
          Container(
            color: Colors.white,
            child: Profile(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(),
        child: GFTabBar(
          initialIndex: currentIndex,
          length: 4,
          controller: tabController,
          tabs: [
            Tab(
              icon: Icon(
                IconData(
                  0xe90f,
                  fontFamily: 'icomoon',
                ),
              ),
              text: "Store",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe90d,
                  fontFamily: 'icomoon',
                ),
              ),
              text: "Saved Items",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe911,
                  fontFamily: 'icomoon',
                ),
              ),
              text: "My Cart",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe912,
                  fontFamily: 'icomoon',
                ),
              ),
              text: "Profile",
            ),
          ],
          indicatorColor: primary,
          labelColor: primary,
          labelPadding: EdgeInsets.all(0),
          tabBarColor: Colors.black,
          unselectedLabelColor: Colors.white,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 10.0,
            color: primary,
            fontFamily: 'OpenSansBold',
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 10.0,
            color: Colors.black,
            fontFamily: 'OpenSansBold',
          ),
        ),
      ),
    );
  }
}
