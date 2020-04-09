import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/tab/mycart.dart';
import 'package:grocery_pro/screens/tab/profile.dart';
import 'package:grocery_pro/screens/tab/saveditems.dart';
import 'package:grocery_pro/screens/tab/store.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/constants.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/settings/globalSettings.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  LocationData currentLocation;
  Location _location = new Location();
  var addressData;
  @override
  void initState() {
    getResult();
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
    if (mounted) {
      setState(() {
        currencyLoading = true;
      });
    }
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

  getResult() async {
    currentLocation = await _location.getLocation();
    if (currentLocation != null) {
      getGeoLocation();
    }
  }

  getGeoLocation() async {
    if (mounted) {
      setState(() {
        isLocationLoading = true;
      });
    }
    await ProductService.geoApi(
            currentLocation.latitude, currentLocation.longitude)
        .then((onValue) {
      print(onValue);
      try {
        if (mounted) {
          setState(() {
            addressData = onValue['results'][0]['formatted_address'];
            isLocationLoading = false;
          });
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
        // firebaseToken();
      } else {}
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  Future<void> configLocalNotification() async {
    var _debugLabelString = "";
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setNotificationReceivedHandler((notification) {
      this.setState(() {
        _debugLabelString =
            "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
        print(_debugLabelString);
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
        print(_debugLabelString);
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      // print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    OneSignal.shared.init(Constants.ONE_SIGNAL_KEY, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });
    OneSignal.shared.setInFocusDisplayType(
      OSNotificationDisplayType.notification,
    );
    OneSignal.shared.getPermissionSubscriptionState().then((onValue) async {
      var playerId = onValue.subscriptionStatus.userId;
      print("kkkkkkkkkkkkk $playerId");
      if (playerId == null) {
        configLocalNotification();
      } else {
        prefs.setString("playerId", playerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currencyLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isLocationLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GFTabBarView(
                  controller: tabController,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Store(
                        currentLocation: addressData,
                      ),
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
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
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
          labelStyle: textBarlowMediumsmBlack(),
          unselectedLabelStyle: textBarlowMediumsmWhite(),
        ),
      ),
    );
  }
}
