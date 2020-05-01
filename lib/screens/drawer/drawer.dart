import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/drawer/aboutus.dart';
import 'package:grocery_pro/screens/drawer/address.dart';
import 'package:grocery_pro/screens/drawer/chatpage.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/screens/product/all_products.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../style/style.dart';

class DrawerPage extends StatefulWidget {
  DrawerPage({Key key, this.locale, this.localizedValues, this.addressData})
      : super(key: key);

  final Map<String, Map<String, String>> localizedValues;
  final String locale, addressData;
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool getTokenValue = true;
  String currency = "";
  @override
  void initState() {
    getToken();
    super.initState();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
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

  selectLanguagesMethod() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(
                  new Radius.circular(24.0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: <Widget>[
                  GFButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('selectedLanguage', 'en');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyApp("en", widget.localizedValues, true),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    type: GFButtonType.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "English",
                          style: hintSfboldBig(),
                        ),
                      ],
                    ),
                  ),
                  GFButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('selectedLanguage', 'ar');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyApp("ar", widget.localizedValues, true),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    type: GFButtonType.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Arbic",
                          style: hintSfboldBig(),
                        ),
                      ],
                    ),
                  ),
                  GFButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('selectedLanguage', 'fr');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyApp("fr", widget.localizedValues, true),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    type: GFButtonType.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "French",
                          style: hintSfboldBig(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

// bool selected=false;
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
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Grocery App',
                      style: textbarlowBoldWhitebig(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: _buildMenuTileList('lib/assets/icons/Home.png',
                      MyLocalizations.of(context).home, 0,
                      notOpen: true,
                      route: Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        languagesSelection: false,
                        currentIndex: 0,
                        addressData: widget.addressData,
                      )),
                ),
                _buildMenuTileList('lib/assets/icons/products.png',
                    MyLocalizations.of(context).products, 0,
                    notOpen: false,
                    route: AllProducts(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      currency: currency,
                    )),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/images/profileIcon.png',
                        MyLocalizations.of(context).profile, 0,
                        notOpen: true,
                        route: Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          languagesSelection: false,
                          currentIndex: 3,
                          addressData: widget.addressData,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/location.png',
                        MyLocalizations.of(context).savedAddress, 0,
                        notOpen: false,
                        route: Address(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/fav.png',
                        MyLocalizations.of(context).savedItems, 0,
                        notOpen: true,
                        route: Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          languagesSelection: false,
                          currentIndex: 1,
                          addressData: widget.addressData,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/chat.png',
                        MyLocalizations.of(context).chat, 0,
                        notOpen: false,
                        route: Chat(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ))
                    : Container(),
                _buildMenuTileList('lib/assets/icons/about.png',
                    MyLocalizations.of(context).aboutUs, 0,
                    notOpen: false,
                    route: AboutUs(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                    )),
                _buildMenuTileList('lib/assets/images/languages.png',
                    MyLocalizations.of(context).selectLanguages, 0,
                    route: null),
                SizedBox(height: 20.0),
                getTokenValue
                    ? _buildMenuTileList1('lib/assets/icons/lg.png',
                        MyLocalizations.of(context).logout, 0,
                        notOpen: true, route: null)
                    : _buildMenuTileList1('lib/assets/icons/lg.png',
                        MyLocalizations.of(context).login, 0,
                        notOpen: false,
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Common.setToken(null).then((value) {
      prefs.setString("userID", null);
      if (value == true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyApp(widget.locale, widget.localizedValues, true),
            ),
            (Route<dynamic> route) => false);
      }
    });
  }

  Widget _buildMenuTileList(String icon, String name, int count,
      {Widget route, bool notOpen, bool check}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          if (route != null && !notOpen) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => route));
          } else if (route != null && notOpen) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => route),
                (Route<dynamic> route) => false);
          } else {
            selectLanguagesMethod();
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
      {Widget route, bool notOpen, bool check}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          if (route != null && !notOpen) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => route));
          } else if (route != null && notOpen) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => route),
                (Route<dynamic> route) => false);
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
                    width: 35, height: 35, color: Color(0xFFF44242)),
                // onTap: (){

                // },
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                name,
                style: textBarlowregredlg(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
