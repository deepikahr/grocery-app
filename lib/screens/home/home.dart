import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/tab/mycart.dart';
import 'package:grocery_pro/screens/tab/profile.dart';
import 'package:grocery_pro/screens/tab/saveditems.dart';
import 'package:grocery_pro/screens/tab/store.dart';
import 'package:grocery_pro/service/constants.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/settings/globalSettings.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/widgets/loader.dart';

SentryError sentryError = new SentryError();

class Home extends StatefulWidget {
  final int currentIndex;
  final Map<String, Map<String, String>> localizedValues;
  final String locale, addressData;
  final bool languagesSelection;
  Home(
      {Key key,
      this.currentIndex,
      this.locale,
      this.localizedValues,
      this.addressData,
      this.languagesSelection})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;
  bool isGetTokenLoading = true,
      currencyLoading = false,
      isCurrentLoactionLoading = false,
      isLocationLoading = false,
      languagesSelection = false;
  int currentIndex = 0;

  @override
  void initState() {
    getGlobalSettingsData();

    configLocalNotification();

    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getGlobalSettingsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        currencyLoading = true;
      });
    }
    getGlobalSettings().then((onValue) {
      try {
        if (onValue['response_data']['currencyCode'] == null) {
          prefs.setString('currency', 'Rs');
        } else {
          prefs.setString(
              'currency', '${onValue['response_data']['currencyCode']}');
        }
        if (widget.languagesSelection == false) {
          if (onValue['response_data']['languageCode'] == null) {
            prefs.setString('selectedLanguage', 'en');
          } else {
            prefs.setString('selectedLanguage',
                '${onValue['response_data']['languageCode']}');
          }
        }
        if (mounted) {
          setState(() {
            currencyLoading = false;
          });
        }
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
    await OneSignal.shared
        .init(Constants.ONE_SIGNAL_KEY, iOSSettings: settings);
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

  tabIcon(icon, title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Icon(
            IconData(
              icon,
              fontFamily: 'icomoon',
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: currencyLoading
          ? SquareLoader()
          : GFTabBarView(
              controller: tabController,
              children: <Widget>[
                Store(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                ),
                SavedItems(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                ),
                MyCart(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                ),
                Profile(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                ),
              ],
            ),
      bottomNavigationBar: GFTabBar(
        initialIndex: currentIndex,
        length: 4,
        controller: tabController,
        tabs: [
          tabIcon(0xe90f, MyLocalizations.of(context).store),
          tabIcon(0xe90d, MyLocalizations.of(context).savedItems),
          tabIcon(0xe911, MyLocalizations.of(context).myCart),
          tabIcon(0xe912, MyLocalizations.of(context).profile)
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        tabBarHeight: 60,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            color: Colors.black),
        labelColor: primary,
        tabBarColor: Colors.black,
        unselectedLabelColor: greyc,
        labelStyle: textBarlowMediumsmBlack(),
        unselectedLabelStyle: textBarlowMediumsmWhite(),
      ),
    );
  }
}
