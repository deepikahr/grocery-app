import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/main.dart';
import 'package:readymadeGroceryApp/screens/authe/changePassword.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/drawer/address.dart';
import 'package:readymadeGroceryApp/screens/orders/orderTab.dart';
import 'package:readymadeGroceryApp/screens/subsription/subscriptionList.dart';
import 'package:readymadeGroceryApp/screens/tab/editprofile.dart';
import 'package:readymadeGroceryApp/screens/tab/wallet.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class Profile extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;
  Profile({Key? key, this.locale, this.localizedValues}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var userInfo, walletAmount;
  bool isGetTokenLoading = false,
      isLanguageSelecteLoading = false,
      isGetLanguagesListLoading = false;
  String? token, userID, currency = "";
  List? languagesList;
  var selectedLanguages;
  @override
  void initState() {
    getToken();
    getLanguagesListData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getToken() async {
    if (mounted) {
      setState(() {
        isGetTokenLoading = true;
      });
    }
    await Common.getCurrency().then((value) {
      currency = value;
    });

    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            token = onValue;
            userInfoMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  userInfoMethod() async {
    await LoginService.getUserInfo().then((onValue) {
      if (mounted) {
        setState(() {
          userInfo = onValue['response_data'];
          userID = userInfo['_id'];
          walletAmount = onValue['response_data']['walletAmount'] ?? 0;
          Common.setUserID(userID!);
          isGetTokenLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getLanguagesListData() async {
    if (mounted) {
      setState(() {
        isGetLanguagesListLoading = true;
      });
    }
    await LoginService.getLanguagesList().then((onValue) {
      if (mounted) {
        setState(() {
          languagesList = onValue['response_data'];
          for (int i = 0; i < languagesList!.length; i++) {
            if (languagesList![i]['languageCode'] == widget.locale) {
              selectedLanguages = languagesList![i]['languageName'];
            }
          }
          isGetLanguagesListLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetLanguagesListLoading = false;
          languagesList = [];
        });
      }
      sentryError.reportError(error, null);
    });
  }

  selectLanguagesMethod() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: new BoxDecoration(
                color: cartCardBg(context),
                borderRadius: new BorderRadius.all(
                  new Radius.circular(24.0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                      padding: EdgeInsets.only(bottom: 25),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          languagesList!.isEmpty ? 0 : languagesList!.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GFButton(
                            onPressed: () async {
                              setState(() {
                                selectedLanguages =
                                    languagesList![i]['languageName'];
                              });
                              await Common.setSelectedLanguage(
                                  languagesList![i]['languageCode']);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MainScreen()),
                                  (Route<dynamic> route) => false);
                            },
                            type: GFButtonType.transparent,
                            child: alertText(context,
                                languagesList![i]['languageName'], null));
                      }),
                ],
              ),
            ),
          );
        });
  }

  logout() async {
    Common.getSelectedLanguage().then((selectedLocale) async {
      Map body = {"language": selectedLocale, "playerId": null};
      LoginService.updateUserInfo(body).then((value) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : appBarPrimary(context, "PROFILE") as PreferredSizeWidget?,
      body: isGetTokenLoading || isGetLanguagesListLoading
          ? SquareLoader()
          : token == null
              ? Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isProfile: true)
              : userInfo == null
                  ? Container()
                  : ListView(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            var result = Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(
                                    locale: widget.locale,
                                    localizedValues: widget.localizedValues,
                                    userInfo: userInfo),
                              ),
                            );
                            result.then((value) => getToken());
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            margin: EdgeInsets.only(
                              top: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(27)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: dark(context)
                                                    .withOpacity(0.29),
                                                blurRadius: 6)
                                          ]),
                                      height: 90.0,
                                      width: 91.0,
                                      child: userInfo['filePath'] == null &&
                                              userInfo['imageUrl'] == null
                                          ? Center(
                                              child: new Container(
                                                width: 200.0,
                                                height: 200.0,
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          27.0),
                                                  image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: new AssetImage(
                                                        'lib/assets/images/profile.png'),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: CachedNetworkImage(
                                                imageUrl: userInfo[
                                                            'filePath'] ==
                                                        null
                                                    ? userInfo['imageUrl']
                                                    : Constants.imageUrlPath! +
                                                        "/tr:dpr-auto,tr:w-500" +
                                                        userInfo['filePath'],
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: 200.0,
                                                  height: 200.0,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                Colors.red,
                                                                BlendMode
                                                                    .colorBurn)),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                        width: 200.0,
                                                        height: 200.0,
                                                        decoration:
                                                            new BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        child: noDataImage()),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Container(
                                                        width: 200.0,
                                                        height: 200.0,
                                                        decoration:
                                                            new BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        child: noDataImage()),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  fit: FlexFit.tight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      alertText(
                                          context,
                                          '${userInfo['firstName'] ?? ""} ${userInfo['lastName'] ?? ""}',
                                          null),
                                      SizedBox(height: 6),
                                      normalText(context,
                                          '${userInfo['email'] ?? ""}'),
                                      SizedBox(height: 6),
                                      normalText(context,
                                          '${userInfo['countryCode'] ?? ""}${userInfo['mobileNumber'] ?? ""}'),
                                      SizedBox(height: 6),
                                      normalText(
                                          context,
                                          (MyLocalizations.of(context)!
                                                      .getLocalizations(
                                                          "WALLET", true) +
                                                  currency +
                                                  walletAmount
                                                      .toDouble()
                                                      .toStringAsFixed(2) ??
                                              "0"))
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 45),
                                            child: SvgPicture.asset(
                                                'lib/assets/icons/editt.svg',
                                                color: primarybg),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                            onTap: () {
                              var result = Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletPage(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues),
                                ),
                              );
                              result.then((value) => getToken());
                            },
                            child: profileText(context, "WALLET")),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Address(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues),
                                ),
                              );
                            },
                            child: profileText(context, "ADDRESS")),
                        languagesList!.length > 0
                            ? SizedBox(height: 15)
                            : Container(),
                        languagesList!.length > 0
                            ? InkWell(
                                onTap: selectLanguagesMethod,
                                child: profileTextRow(context,
                                    "CHANGE_LANGUAGE", selectedLanguages ?? ""))
                            : Container(),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              var result = Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrdersTab(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues),
                                ),
                              );
                              result.then((value) => getToken());
                            },
                            child: profileText(context, "MY_ORDERS")),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubScriptionList(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues),
                                ),
                              );
                            },
                            child: profileText(context, "SUBSCRIPTION")),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePassword(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues),
                                ),
                              );
                            },
                            child: profileText(context, "CHANGE_PASSWORD")),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: logout,
                            child: profileText(context, "LOGOUT")),
                        SizedBox(height: 15),
                      ],
                    ),
    );
  }
}
