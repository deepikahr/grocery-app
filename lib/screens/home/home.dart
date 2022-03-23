import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:readymadeGroceryApp/service/locationService.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/socket.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class Home extends StatefulWidget {
  final int? currentIndex;
  final Map? localizedValues;
  final String? locale;
  final bool? isTest;

  Home(
      {Key? key,
      this.currentIndex,
      this.locale,
      this.localizedValues,
      this.isTest})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController? tabController;
  bool currencyLoading = false,
      isCurrentLoactionLoading = false,
      getTokenValue = false;
  int? currentIndex = 0, cartData;
  String? currency = "";
  var addressData;

  var socketService = SocketService();
  void initState() {
    socketService.socketInitialize();
    if (widget.currentIndex != null) {
      if (mounted) {
        setState(() {
          currentIndex = widget.currentIndex;
        });
      }
    }
    getToken();
    if (widget.isTest == null || !widget.isTest!) {
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
      if (onValue['response_data'] != null &&
          onValue['response_data']['currencySymbol'] != null) {
        await Common.setCurrency(onValue['response_data']['currencySymbol']);
        await Common.setCurrencyCode(onValue['response_data']['currencyCode']);
        await Common.getCurrency()
            .then((value) => setState(() => currency = value));
      } else {
        await Common.setCurrency('\$');
        await Common.setCurrencyCode('USD');
        await Common.getCurrency()
            .then((value) => setState(() => currency = value));
      }
    }).catchError((error) async {
      if (mounted) {
        setState(() {
          currencyLoading = false;
          Common.setCurrency('\$');
          Common.setCurrencyCode('USD');
        });
        await Common.getCurrency()
            .then((value) => setState(() => currency = value));
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
    if (tabController != null) tabController!.dispose();
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
      bool? permission = await LocationUtils().locationPermission();

      if (permission) {
        Position position = await LocationUtils().currentLocation();
        var addressValue = await LocationUtils().getAddressFromLatLng(
          LatLng(
            position.latitude,
            position.longitude,
          ),
        );
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (mounted) {
          setState(() {
            addressData = addressValue.formattedAddress;
            isCurrentLoactionLoading = false;
          });
        }
        await Common.setCountryInfo(placemarks[0].isoCountryCode ?? '');
        await Common.setCurrentLocation(addressData);
      }
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
          label: MyLocalizations.of(context)!.getLocalizations("STORE"),
          icon: buildIcon(
              context,
              const IconData(
                0xe90f,
                fontFamily: 'icomoon',
              ),
              0)),
      BottomNavigationBarItem(
          label: MyLocalizations.of(context)!.getLocalizations("FAVORITE"),
          icon: buildIcon(
              context,
              const IconData(
                0xe90d,
                fontFamily: 'icomoon',
              ),
              0)),
      BottomNavigationBarItem(
          label: MyLocalizations.of(context)!.getLocalizations("MY_CART"),
          icon: buildIcon(
              context,
              const IconData(
                0xe911,
                fontFamily: 'icomoon',
              ),
              cartData)),
      BottomNavigationBarItem(
          label: MyLocalizations.of(context)!.getLocalizations("PROFILE"),
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
      backgroundColor: bg(context),
      key: _scaffoldKey,
      // backgroundColor: Colors.white,
      appBar: currentIndex == 0
          ? appBarPrimarynoradiusWithContent(
              context,
              deliveryAddress(),
              true,
              true,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                    },
                    child:
                    Stack(
                      children: [
                        Icon(Icons.shopping_cart),
                        Positioned(
                          right: 2,
                          child: GFBadge(
                            child: Text(
                              '${cartData.toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "bold", fontSize: 11),
                            ),
                            shape: GFBadgeShape.circle,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ),
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
                      padding: EdgeInsets.only(right: 15, left: 10),
                      child: Icon(Icons.notifications_none),
                    ),
                  ),
                ],
              ),
            ) as PreferredSizeWidget?
          : null,



      drawer: Drawer(
        child: DrawerPage(
            locale: widget.locale,
            localizedValues: widget.localizedValues,
            addressData: addressData ?? "",
            scaffoldKey: _scaffoldKey),
      ),
      body: currencyLoading ? SquareLoader() : _screens[currentIndex!],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        currentIndex: currentIndex!,
        type: BottomNavigationBarType.fixed,
        onTap: _onTapped,
        items: items,
      ),
    );
  }
}
