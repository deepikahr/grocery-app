import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/drawer/aboutus.dart';
import 'package:readymadeGroceryApp/screens/drawer/address.dart';
import 'package:readymadeGroceryApp/screens/drawer/chatpage.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/product/all_products.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import '../../main.dart';
import '../../style/style.dart';

class DrawerPage extends StatefulWidget {
  DrawerPage({Key key, this.locale, this.localizedValues, this.addressData})
      : super(key: key);

  final Map localizedValues;
  final String locale, addressData;
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool getTokenValue = true;
  String currency = "", newValue;

  @override
  void initState() {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Constants.APP_NAME.split(' ').join('\n'),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textbarlowBoldWhitebig(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
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
                        route: Chat(
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
    await Common.setSelectedLanguage(null);
    await Common.setToken(null);
    await Common.setUserID(null);
    main();
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
