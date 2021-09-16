import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/categories/allcategories.dart';
import 'package:readymadeGroceryApp/screens/drawer/about-us.dart';
import 'package:readymadeGroceryApp/screens/drawer/address.dart';
import 'package:readymadeGroceryApp/screens/drawer/chatpage.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/orders/orderTab.dart';
import 'package:readymadeGroceryApp/screens/product/all_deals.dart';
import 'package:readymadeGroceryApp/screens/subsription/subscriptionList.dart';
import 'package:readymadeGroceryApp/screens/product/all_products.dart';
import 'package:readymadeGroceryApp/screens/drawer/TandC-PP.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:share/share.dart';
import '../../main.dart';

SentryError sentryError = new SentryError();

class DrawerPage extends StatefulWidget {
  DrawerPage(
      {Key? key,
      this.locale,
      this.localizedValues,
      this.addressData,
      this.scaffoldKey})
      : super(key: key);

  final Map? localizedValues;
  final String? locale, addressData;
  final scaffoldKey;
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool getTokenValue = true;
  String currency = "";

  @override
  void initState() {
    getToken();
    Common.getTheme().then((isDark) {
      isDark ? Color(0xFAAACF2D) : Color(0xFFFFCF2D);
    });
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
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
        child: Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            color: Color(0xFF000000),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Image.asset(
                      "lib/assets/logo.png",
                      height: 80,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildMenuTileList(
                      'lib/assets/icons/Home.png', "HOME_PAGE",
                      route: Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currentIndex: 0,
                      )),
                ),
                _buildMenuTileList('lib/assets/icons/products.png', "PRODUCTS",
                    route: AllProducts(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      pageTitle: "PRODUCTS",
                    )),
                _buildMenuTileList(
                  'lib/assets/icons/categories.png',
                  "ALL_CATEGROIES",
                  route: AllCategories(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    getTokenValue: getTokenValue,
                  ),
                ),
                _buildMenuTileList('lib/assets/icons/deals.png', "TOP_DEALS",
                    route: AllDealsList(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currency: currency,
                        token: getTokenValue,
                        title: "TOP_DEALS")),
                getTokenValue
                    ? _buildMenuTileList(
                        'lib/assets/images/profileIcon.png', "PROFILE",
                        route: Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 3,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList(
                        'lib/assets/icons/history.png', "MY_ORDERS",
                        route: OrdersTab(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList(
                        'lib/assets/icons/location.png', "ADDRESS",
                        route: Address(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/fav.png', "FAVORITE",
                        route: Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 1,
                        ))
                    : Container(),
                getTokenValue
                    ? _buildMenuTileList('lib/assets/icons/chat.png', "CHAT",
                        route: Chat(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ))
                    : Container(),
                _buildMenuTileList('lib/assets/icons/about.png', "ABOUT_US",
                    route: AboutUs(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues)),
                _buildMenuTileList(
                  'lib/assets/icons/tc.png',
                  "PRIVACY_POLICY",
                  route: TandCandPrivacyPolicy(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      endPoint: "/pages/privacy-policy",
                      title: "PRIVACY_POLICY"),
                ),
                _buildMenuTileList(
                  'lib/assets/icons/tc.png',
                  "TERMS_CONDITIONS",
                  route: TandCandPrivacyPolicy(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      endPoint: "/pages/terms-and-conditions",
                      title: "TERMS_CONDITIONS"),
                ),
                getTokenValue
                    ? _buildMenuTileList(
                        'lib/assets/icons/subscription_list.png',
                        "SUBSCRIPTION",
                        route: SubScriptionList(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ),
                      )
                    : Container(),
                // _buildMenuTileList(
                //   'lib/assets/icons/refer.png',
                //   "REFERRAL",
                //   route: ReferralPage(
                //     locale: widget.locale,
                //     localizedValues: widget.localizedValues,
                //   ),
                // ),
                InkWell(
                    onTap: () {
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      Share.share(
                          MyLocalizations.of(context)!
                                  .getLocalizations("SHARE_MESSAGE") +
                              " " +
                              Constants.storeUrl,
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                    child: buildDrawer(
                        context, "SHARE", "lib/assets/icons/share.png")),
                SwitchListTile(
                    activeColor: primary(context),
                    inactiveTrackColor: greyb(context),
                    title: Text(
                      MyLocalizations.of(context)!
                          .getLocalizations("DARK_THEME"),
                      style: textBarlowregwhitelg(context),
                    ),
                    value: themeChange.darkTheme,
                    onChanged: (bool value) {
                      themeChange.darkTheme = value;
                      Common.setTheme(value);
                    }),
                SizedBox(height: 20.0),
                getTokenValue
                    ? _buildMenuTileList1('lib/assets/icons/lg.png', "LOGOUT",
                        route: null)
                    : _buildMenuTileList1('lib/assets/icons/lg.png', "LOGIN",
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
      Map body = {"language": selectedLocale, "playerId": null};
      LoginService.updateUserInfo(body).then((value) async {
        Navigator.pop(context);
        showSnackbar(MyLocalizations.of(context)!
            .getLocalizations("LOGOUT_SUCCESSFULL"));
        Future.delayed(Duration(milliseconds: 1500), () async {
          await Common.deleteToken();
          await Common.deleteUserId();
          await Common.setCartData(null);
          await Common.setCartDataCount(0);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen()),
              (Route<dynamic> route) => false);
        });
      });
    });
  }

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }

  Widget _buildMenuTileList(icon, name, {Widget? route}) {
    return InkWell(
        onTap: () {
          if (route != null) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => route),
            );
          }
        },
        child: buildDrawer(context, name, icon));
  }

  Widget _buildMenuTileList1(icon, String name, {Widget? route}) {
    return InkWell(
      onTap: () {
        if (route != null) {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => route));
        } else {
          logout();
        }
      },
      child: buildDrawerLogOutLogin(context, name, icon, getTokenValue),
    );
  }
}
