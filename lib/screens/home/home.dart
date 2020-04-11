import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/tab/mycart.dart';
import 'package:grocery_pro/screens/tab/profile.dart';
import 'package:grocery_pro/screens/tab/saveditems.dart';
import 'package:grocery_pro/screens/tab/store.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/constants.dart';
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
  Home(
      {Key key,
      this.currentIndex,
      this.locale,
      this.localizedValues,
      this.addressData})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;
  bool isGetTokenLoading = true,
      currencyLoading = false,
      isCurrentLoactionLoading = false,
      isLocationLoading = false;
  int currentIndex = 0;

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

  getToken() async {
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        // firebaseToken();
      } else {}
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
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
        if (onValue['response_data']['currency'] == null &&
            onValue['response_data']['currency'][0]['currencySign'] == null) {
          prefs.setString('currency', 'Rs');
        } else {
          prefs.setString('currency',
              '${onValue['response_data']['currency'][0]['currencySign']}');
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

    prefs.setString("playerId", playerId);
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
          Store(),
          SavedItems(),
          MyCart(),
          Profile(),
        ],
      ),
      bottomNavigationBar: GFTabBar(
        initialIndex: currentIndex,
        length: 4,
        controller: tabController,
        tabs: [
          tabIcon(0xe90f, 'Store'),
          tabIcon(0xe90d, 'Saved Items'),
          tabIcon(0xe911, 'My Cart'),
          tabIcon(0xe912, 'Profile')
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
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
