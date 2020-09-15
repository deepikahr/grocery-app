import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/drawer/drawer.dart';
import 'package:readymadeGroceryApp/screens/tab/mycart.dart';
import 'package:readymadeGroceryApp/screens/tab/profile.dart';
import 'package:readymadeGroceryApp/screens/tab/saveditems.dart';
import 'package:readymadeGroceryApp/screens/tab/searchitem.dart';
import 'package:readymadeGroceryApp/screens/tab/store.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:location/location.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class Home extends StatefulWidget {
  final int currentIndex;
  final Map localizedValues;
  final String locale;
  final bool isTest;
  Home(
      {Key key,
      this.currentIndex,
      this.locale,
      this.localizedValues,
      this.isTest})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;
  bool currencyLoading = false,
      isCurrentLoactionLoading = false,
      getTokenValue = false;
  int currentIndex = 0, cartData;
  LocationData currentLocation;
  Location _location = new Location();
  String currency = "";

  var addressData;

  void initState() {
    if (widget.currentIndex != null) {
      if (mounted) {
        setState(() {
          currentIndex = widget.currentIndex;
        });
      }
    }
    getToken();
    if (widget.isTest == null || !widget.isTest) {
      getResult();
    }
    getGlobalSettingsData();
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  getGlobalSettingsData() async {
    if (mounted) {
      setState(() {
        currencyLoading = true;
      });
    }
    LoginService.getLocationformation().then((onValue) async {
      if (mounted) {
        setState(() {
          currencyLoading = false;
        });
      }
      if (onValue['response_data']['currencySymbol'] == null) {
        await Common.setCurrency('\$');
        await Common.getCurrency().then((value) {
          currency = value;
        });
      } else {
        currency = onValue['response_data']['currencySymbol'];
        await Common.setCurrency(currency);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          currencyLoading = false;
          Common.setCurrency('\$');
        });
      }
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
      if (mounted) {
        setState(() {
          getTokenValue = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  void dispose() {
    if (tabController != null) tabController.dispose();
    super.dispose();
  }

  deliveryAddress() {
    return locationText(context, addressData == null ? null : "YOUR_LOCATION",
        addressData ?? Constants.appName);
  }

  getResult() async {
    await Common.getCurrentLocation().then((address) async {
      if (address != null) {
        if (mounted) {
          setState(() {
            addressData = address;
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
          isCurrentLoactionLoading = false;
        });
      }
      await Common.setCurrentLocation(addressData);
      return first;
    });
  }

  _onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (getTokenValue) {
      CounterModel().getCartDataCountMethod().then((res) {
        if (mounted) {
          setState(() {
            cartData = res;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          cartData = 0;
        });
      }
    }
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          title: Text(MyLocalizations.of(context).getLocalizations("STORE")),
          icon: buildIcon(
              context,
              const IconData(
                0xe90f,
                fontFamily: 'icomoon',
              ),
              0)),
      BottomNavigationBarItem(
          title: Text(MyLocalizations.of(context).getLocalizations("FAVORITE")),
          icon: buildIcon(
              context,
              const IconData(
                0xe90d,
                fontFamily: 'icomoon',
              ),
              0)),
      BottomNavigationBarItem(
          title: Text(MyLocalizations.of(context).getLocalizations("MY_CART")),
          icon: buildIcon(
              context,
              const IconData(
                0xe911,
                fontFamily: 'icomoon',
              ),
              cartData)),
      BottomNavigationBarItem(
          title: Text(MyLocalizations.of(context).getLocalizations("PROFILE")),
          icon: buildIcon(
              context,
              const IconData(
                0xe912,
                fontFamily: 'icomoon',
              ),
              0)),
    ];

    List<Widget> _screens = [
      Store(locale: widget.locale, localizedValues: widget.localizedValues),
      SavedItems(
          locale: widget.locale, localizedValues: widget.localizedValues),
      MyCart(locale: widget.locale, localizedValues: widget.localizedValues),
      Profile(locale: widget.locale, localizedValues: widget.localizedValues),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: currentIndex == 0
          ? appBarWhite(
              context,
              deliveryAddress(),
              true,
              true,
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchItem(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currency: currency,
                        token: getTokenValue,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 15, left: 15),
                  child: Icon(Icons.search),
                ),
              ),
            )
          : null,
      drawer: Drawer(
        child: DrawerPage(
            locale: widget.locale,
            localizedValues: widget.localizedValues,
            addressData: addressData ?? ""),
      ),
      body: currencyLoading ? SquareLoader() : _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.black,
          unselectedItemColor: greyc,
          type: BottomNavigationBarType.fixed,
          fixedColor: primary,
          onTap: _onTapped,
          items: items),
    );
  }
}
