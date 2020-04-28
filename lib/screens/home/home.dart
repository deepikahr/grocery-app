import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/home/drawer.dart';
import 'package:grocery_pro/screens/tab/mycart.dart';
import 'package:grocery_pro/screens/tab/profile.dart';
import 'package:grocery_pro/screens/tab/saveditems.dart';
import 'package:grocery_pro/screens/tab/searchitem.dart';
import 'package:grocery_pro/screens/tab/store.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/constants.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/settings/globalSettings.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:location/location.dart';
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
      languagesSelection = false,
      getTokenValue = false;
  int currentIndex = 0;
  var language, currency;
  List searchProductList, favProductList;
  LocationData currentLocation;
  Location _location = new Location();
  var addressData;
  void initState() {
    getResult();
    getGlobalSettingsData();
    configLocalNotification();
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  getGlobalSettingsData() async {
    if (mounted) {
      setState(() {
        currencyLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getGlobalSettings().then((onValue) {
      try {
        if (onValue['response_data']['currencyCode'] == null) {
          prefs.setString('currency', 'Rs');
          if (mounted) {
            setState(() {
              currencyLoading = false;
            });
          }
        } else {
          prefs.setString(
              'currency', '${onValue['response_data']['currencyCode']}');
          if (mounted) {
            setState(() {
              currencyLoading = false;
            });
          }
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
        if (mounted) {
          setState(() {
            getTokenValue = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            getTokenValue = false;
          });
        }
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getFavListApi() async {
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            favProductList = onValue['response_data'];
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getProductListMethod() async {
    await ProductService.getProductListAll().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              searchProductList = onValue['response_data'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              searchProductList = [];
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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

  deliveryAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                MyLocalizations.of(context).deliveryAddress,
                style: textBarlowRegularrBlacksm(),
              ),
              Text(
                addressData != null
                    ? addressData.substring(0, 22) + '...'
                    : widget.addressData.substring(0, 22) + '...',
                style: textBarlowSemiBoldBlackbig(),
              )
            ],
          ),
        ),
      ],
    );
  }

  getResult() async {
    Common.getCurrentLocation().then((address) async {
      if (address != null) {
        if (mounted) {
          setState(() {
            addressData = address;
            print(address);
          });
        }
      }
      currentLocation = await _location.getLocation();
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      if (mounted) {
        setState(() {
          addressData = first.addressLine;
        });
      }
      print(addressData);
      Common.setCurrentLocation(addressData);
      return first;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentIndex != null) {
      if (mounted) {
        setState(() {
          currentIndex = widget.currentIndex;
        });
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GFAppBar(
        backgroundColor: bg,
        elevation: 0,
        title: deliveryAddress(),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchItem(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      productsList: searchProductList,
                      currency: currency,
                      token: getTokenValue,
                      favProductList: getTokenValue ? favProductList : null),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: Icon(
                Icons.search,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: DrawerPage(),
      ),
      body: currencyLoading
          ? SquareLoader()
          : GFTabBarView(
              physics: NeverScrollableScrollPhysics(),
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
