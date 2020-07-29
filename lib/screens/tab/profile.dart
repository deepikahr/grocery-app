import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/main.dart';
import 'package:readymadeGroceryApp/screens/authe/changePassword.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/drawer/address.dart';
import 'package:readymadeGroceryApp/screens/orders/orders.dart';
import 'package:readymadeGroceryApp/screens/tab/editprofile.dart';
import 'package:readymadeGroceryApp/screens/webView/webView.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

SentryError sentryError = new SentryError();

class Profile extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  Profile({Key key, this.locale, this.localizedValues}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userInfo;
  bool isGetTokenLoading = false,
      isLanguageSelecteLoading = false,
      isGetLanguagesListLoading = false;
  String token, userID;
  List languagesList;

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
      print(onValue);

      if (mounted) {
        setState(() {
          userInfo = onValue['response_data'];
          userID = userInfo['_id'];
          Common.setUserID(userID);
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
                color: Colors.white,
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
                      itemCount: languagesList.length == null
                          ? 0
                          : languagesList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GFButton(
                          onPressed: () async {
                            await Common.setSelectedLanguage(
                                languagesList[i]['languageCode']);
                            main();
                          },
                          type: GFButtonType.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                languagesList[i]['languageName'],
                                style: hintSfboldBig(),
                              ),
                              Container()
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  elevation: 0,
                  title: Text(
                    MyLocalizations.of(context).getLocalizations("PROFILE"),
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: primary,
                  automaticallyImplyLeading: false,
                ),
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
                                                color: Colors.black
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
                                              child: new Container(
                                                width: 200.0,
                                                height: 200.0,
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: new NetworkImage(userInfo[
                                                                'filePath'] ==
                                                            null
                                                        ? userInfo['imageUrl']
                                                        : Constants
                                                                .imageUrlPath +
                                                            "/tr:dpr-auto,tr:w-500" +
                                                            userInfo[
                                                                'filePath']),
                                                  ),
                                                ),
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: .0, bottom: 6.0),
                                        child: Text(
                                          '${userInfo['firstName'] ?? ""} ${userInfo['lastName'] ?? ""}',
                                          style: textBarlowMediumBlack(),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${userInfo['email'] ?? ""}',
                                            style: textbarlowmedium(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, right: .0),
                                        child: Text(
                                          '${userInfo['mobileNumber'] ?? ""}',
                                          style: textbarlowmedium(),
                                        ),
                                      ),
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
                                                'lib/assets/icons/editt.svg'),
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
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            var result = Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Address(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                ),
                              ),
                            );
                            result.then((value) => getToken());
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F7F7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 20.0,
                                      right: 20.0),
                                  child: Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations("ADDRESS")
                                        .toUpperCase(),
                                    style: textBarlowMediumBlack(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        languagesList.length > 0
                            ? SizedBox(height: 15)
                            : Container(),
                        languagesList.length > 0
                            ? InkWell(
                                onTap: () {
                                  selectLanguagesMethod();
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF7F7F7),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                            left: 20.0,
                                            right: 20.0),
                                        child: Text(
                                          MyLocalizations.of(context)
                                              .getLocalizations(
                                                  "SELECT_LANGUAGE"),
                                          style: textBarlowMediumBlack(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            var result = Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Orders(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                  userID: userID,
                                ),
                              ),
                            );
                            result.then((value) => getToken());
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F7F7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 20.0,
                                      right: 20.0),
                                  child: Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations("MY_ORDERS"),
                                    style: textBarlowMediumBlack(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            var result = Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePassword(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                ),
                              ),
                            );
                            result.then((value) => getToken());
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F7F7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 20.0,
                                      right: 20.0),
                                  child: Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations("CHANGE_PASSWORD"),
                                    style: textBarlowMediumBlack(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
      bottomNavigationBar: isGetTokenLoading ||
              isGetLanguagesListLoading ||
              token == null ||
              userInfo == null
          ? Container(height: 1)
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => WebViewPage(
                                    locale: widget.locale,
                                    localizedValues: widget.localizedValues,
                                    title: MyLocalizations.of(context)
                                        .getLocalizations("TERMS_CONDITIONS"),
                                    url: Constants.baseUrl +
                                        "/terms-and-conditions",
                                  )));
                    },
                    child: Text(
                      MyLocalizations.of(context)
                          .getLocalizations("TERMS_CONDITIONS"),
                      style: textBarlowmediumLink(),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => WebViewPage(
                                    locale: widget.locale,
                                    localizedValues: widget.localizedValues,
                                    title: MyLocalizations.of(context)
                                        .getLocalizations("PRIVACY_POLICY"),
                                    url: Constants.baseUrl + "/privacy-policy",
                                  )));
                    },
                    child: Text(
                      MyLocalizations.of(context)
                          .getLocalizations("PRIVACY_POLICY"),
                      style: textBarlowmediumLink(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
