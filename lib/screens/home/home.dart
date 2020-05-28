import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/drawer/drawer.dart';
import 'package:readymadeGroceryApp/screens/tab/mycart.dart';
import 'package:readymadeGroceryApp/screens/tab/profile.dart';
import 'package:readymadeGroceryApp/screens/tab/saveditems.dart';
import 'package:readymadeGroceryApp/screens/tab/searchitem.dart';
import 'package:readymadeGroceryApp/screens/tab/store.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/fav-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/settings/globalSettings.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

SentryError sentryError = new SentryError();

class Home extends StatefulWidget {
  final int currentIndex;
  final Map localizedValues;
  final String locale;
  Home({
    Key key,
    this.currentIndex,
    this.locale,
    this.localizedValues,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;
  bool currencyLoading = false,
      isCurrentLoactionLoading = false,
      getTokenValue = false;
  int currentIndex = 0;
  List searchProductList, favProductList;
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
    getResult();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getGlobalSettings().then((onValue) {
      try {
        if (onValue['response_data']['currencyCode'] == null) {
          prefs.setString('currency', 'Rs');
          currency = prefs.getString('currency');
          if (mounted) {
            setState(() {
              currencyLoading = false;
            });
          }
        } else {
          prefs.setString(
              'currency', '${onValue['response_data']['currencyCode']}');
          currency = prefs.getString('currency');
          if (mounted) {
            setState(() {
              currencyLoading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            currencyLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          currencyLoading = false;
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

  getFavListApi() async {
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            favProductList = onValue['response_data'];
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            favProductList = [];
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          favProductList = [];
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductListMethod() async {
    await ProductService.getProductListAll(1).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              searchProductList = onValue['response_data']['products'];
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
        if (mounted) {
          setState(() {
            searchProductList = [];
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          searchProductList = [];
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
                MyLocalizations.of(context).yourLocation,
                style: textBarlowRegularrBlacksm(),
              ),
              Text(
                addressData ?? "",
                overflow: TextOverflow.ellipsis,
                style: textAddressLocation(),
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
      Common.setCurrentLocation(addressData);
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
    List<Widget> _screens = [
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
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: currentIndex == 0
          ? GFAppBar(
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
                            favProductList:
                                getTokenValue ? favProductList : null),
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
            )
          : null,
      drawer: Drawer(
        child: DrawerPage(
          locale: widget.locale,
          localizedValues: widget.localizedValues,
          addressData: addressData ?? "",
        ),
      ),
      body: currencyLoading ? SquareLoader() : _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.black,
        unselectedItemColor: greyc,
        type: BottomNavigationBarType.fixed,
        fixedColor: primary,
        onTap: _onTapped,
        items: [
          BottomNavigationBarItem(
            title: Text(MyLocalizations.of(context).store),
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                IconData(
                  0xe90f,
                  fontFamily: 'icomoon',
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            title: Text(MyLocalizations.of(context).savedItems),
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                IconData(
                  0xe90d,
                  fontFamily: 'icomoon',
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            title: Text(MyLocalizations.of(context).myCart),
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                IconData(
                  0xe911,
                  fontFamily: 'icomoon',
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            title: Text(MyLocalizations.of(context).profile),
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                IconData(
                  0xe912,
                  fontFamily: 'icomoon',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
