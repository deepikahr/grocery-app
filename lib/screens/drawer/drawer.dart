import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/categories/allcategories.dart';
import 'package:readymadeGroceryApp/screens/drawer/aboutus.dart';
import 'package:readymadeGroceryApp/screens/drawer/address.dart';
import 'package:readymadeGroceryApp/screens/drawer/newChatPage.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/orders/orders.dart';
import 'package:readymadeGroceryApp/screens/product/all_deals.dart';
import 'package:readymadeGroceryApp/screens/product/all_products.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import '../../main.dart';
import '../../style/style.dart';

SentryError sentryError = new SentryError();

class DrawerPage extends StatefulWidget {
  DrawerPage({Key key, this.locale, this.localizedValues, this.addressData})
      : super(key: key);

  final Map localizedValues;
  final String locale, addressData;
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool getTokenValue = true, isLogoGetLoading = false;
  String currency = "", logo;

  @override
  void initState() {
    getLogo();
    getToken();
    super.initState();
  }

  getToken() async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
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
    });
  }

  getLogo() {
    if (mounted) {
      setState(() {
        isLogoGetLoading = true;
      });
    }
    LoginService.aboutUs().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              isLogoGetLoading = false;
              if (onValue['response_data'][0]['userApp']['filePath'] == null) {
                logo = onValue['response_data'][0]['userApp']['imageUrl'];
              } else {
                logo = Constants.imageUrlPath +
                    "tr:dpr-auto,tr:w-500" +
                    onValue['response_data'][0]['userApp']['filePath'];
              }
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
  Widget build(BuildContext context) {
    return Container(
        child: Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            color: Color(0xFF000000),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 40),
                isLogoGetLoading
                    ? Container(height: 100)
                    : logo == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                Constants.APP_NAME.split(' ').join('\n'),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: textbarlowBoldWhitebig(),
                              ),
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.all(10),
                            child: Center(
                              child: Image.network(
                                logo,
                                height: 80,
                              ),
                            ),
                          ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildMenuTileList('lib/assets/icons/Home.png',
                      MyLocalizations.of(context).home, 0,
                      route: Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currentIndex: 0,
                      )),
                ),
                _buildMenuTileList('lib/assets/icons/products.png',
                    MyLocalizations.of(context).products, 0,
                    route: AllProducts(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      currency: currency,
                    )),
                _buildMenuTileList(
                  'lib/assets/icons/categories.png',
                  MyLocalizations.of(context).allCategories,
                  0,
                  route: AllCategories(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    getTokenValue: getTokenValue,
                  ),
                ),
                _buildMenuTileList('lib/assets/icons/deals.png',
                    MyLocalizations.of(context).topDeals, 0,
                    route: AllDealsList(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currency: currency,
                        token: getTokenValue,
                        dealType: "TopDeals",
                        title: MyLocalizations.of(context).topDeals)),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/images/profileIcon.png',
                        MyLocalizations.of(context).profile, 0,
                        route: Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 3,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/history.png',
                        MyLocalizations.of(context).myOrders, 0,
                        route: Orders(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/location.png',
                        MyLocalizations.of(context).address, 0,
                        route: Address(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/fav.png',
                        MyLocalizations.of(context).savedItems, 0,
                        route: Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 1,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/chat.png',
                        MyLocalizations.of(context).chat, 0,
                        route: NewChatAndHistoryPage(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ))
                    : Container(),
                _buildMenuTileList('lib/assets/icons/about.png',
                    MyLocalizations.of(context).aboutUs, 0,
                    route: AboutUs(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                    )),
                SizedBox(height: 20.0),
                getTokenValue
                    ? _buildMenuTileList1('lib/assets/icons/lg.png',
                        MyLocalizations.of(context).logout, 0, route: null)
                    : _buildMenuTileList1('lib/assets/icons/lg.png',
                        MyLocalizations.of(context).login, 0,
                        route: Login(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        )),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  logout() async {
    Common.getSelectedLanguage().then((selectedLocale) async {
      await LoginService.setLanguageCodeToProfileDefult(selectedLocale)
          .then((value) async {
        await Common.setToken(null);
        await Common.setUserID(null);
        main();
      });
    });
  }

  Widget _buildMenuTileList(String icon, String name, int count,
      {Widget route, bool check}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => route));
          }
        },
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  leading: Image.asset(
                    icon,
                    width: 35,
                    height: 35,
                    color: Colors.white,
                  ),
                  selected: true,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  name,
                  style: textBarlowregwhitelg(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTileList1(String icon, String name, int count,
      {Widget route, bool check}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => route));
          } else {
            logout();
          }
        },
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ListTile(
                leading: Image.asset(icon,
                    width: 35,
                    height: 35,
                    color: !getTokenValue ? Colors.green : Color(0xFFF44242)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                name,
                style: !getTokenValue
                    ? textBarlowregredGreen()
                    : textBarlowregredlg(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
