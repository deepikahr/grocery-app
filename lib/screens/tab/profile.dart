import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/main.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/chat/chatpage.dart';
import 'package:grocery_pro/screens/orders/orders.dart';
import 'package:grocery_pro/screens/address/address.dart';
import 'package:grocery_pro/screens/payment/addCard.dart';
import 'package:grocery_pro/screens/tab/editprofile.dart';
import 'package:grocery_pro/service/payment-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/widgets/loader.dart';

SentryError sentryError = new SentryError();

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userInfo;
  bool isLoading = false, logoutLoading = false;
  bool isGetTokenLoading = false;
  List orderList = List();
  List cardList = List();
  String token;

  String userID;
  bool isProfile = true, isCardListLoading = false, isCardDelete = false;
  @override
  void initState() {
    getToken();
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
      try {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
              token = onValue;
              fetchCardInfo();
              getUserInfoApi();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
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

  fetchCardInfo() async {
    if (mounted) {
      setState(() {
        isCardListLoading = true;
      });
    }
    Common.getCardInfo().then((value) {
      if (value == null) {
        if (mounted) {
          setState(() {
            fetchCardInfoMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isCardListLoading = false;
            cardList = value['response_data'];
            fetchCardInfoMethod();
          });
        }
      }
    });
  }

  fetchCardInfoMethod() async {
    await PaymentService.getCardList().then((onValue) {
      if (mounted) {
        setState(() {
          cardList = onValue['response_data'];
          isCardListLoading = false;
        });
      }
    });
  }

  deleteCard(id) async {
    if (mounted) {
      setState(() {
        isCardDelete = true;
      });
    }
    await PaymentService.deleteCard(id).then((onValue) {
      if (mounted) {
        setState(() {
          fetchCardInfo();
          isCardDelete = false;
          Navigator.pop(context);
        });
      }
    });
  }

  getUserInfoApi() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    Common.getUserInfo().then((value) {
      print(value);
      if (value == null) {
        if (mounted) {
          setState(() {
            userInfoMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            userInfo = value['response_data']['userInfo'];
            userID = userInfo['_id'];
            isLoading = false;
            userInfoMethod();
          });
        }
      }
    });
  }

  userInfoMethod() async {
    await LoginService.getUserInfo().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isLoading = false;
            userInfo = onValue['response_data']['userInfo'];

            userID = userInfo['_id'];
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  logout() {
    if (mounted) {
      setState(() {
        logoutLoading = true;
      });
    }
    Common.setToken(null).then((value) {
      if (value == true) {
        if (mounted) {
          setState(() {
            logoutLoading = false;
          });
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MyApp(),
            ),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget itemCard = cardList.length == 0
        ? InkWell(
            onTap: () {
              var result = Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => new AddCard(),
                ),
              );

              if (result != null) {
                result.then((onValue) {
                  fetchCardInfo();
                  if (mounted) {
                    setState(() {
                      cardList = cardList;
                    });
                  }
                });
              }
            },
            child: Container(
//              padding: const EdgeInsets.only(left: 15.0),
              height: 141,
              width: 232,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.black54,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add new card',
                    style: textBarlowRegularBlack(),
                  )
                ],
              ),
            ),
          )
        : Row(
            children: <Widget>[
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: cardList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8, right: 8, left: 6),
                    child: Container(
                      height: 141,
                      width: 232,
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.0,
                                0.4,
                                0.6,
                                1.0
                              ],
                              colors: [
                                Color(0xFF5FE5CF),
                                Color(0xFF5FB8E5),
                                Color(0xFF5FB8E5),
                                Color(0xFF5FB8E5),
                              ]),

//                          color: Color(0xFF5FB8E5),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                cardList[index]['cardImage'] == null
                                    ? Image.asset(
                                        'lib/assets/icons/mastercard-logo.png')
                                    : Image.network(
                                        '${cardList[index]['cardImage']}',
                                      ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '${cardList[index]['bank']}',
                                    style: textBarlowRegularWhite(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog<Null>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: 270.0,
                                          child: new AlertDialog(
                                            title: new Text(
                                              'Are You Sure?',
                                              style: hintSfsemiboldred(),
                                            ),
                                            content: new SingleChildScrollView(
                                              child: new ListBody(
                                                children: <Widget>[
                                                  new Text(
                                                    'Delete Card',
                                                    style:
                                                        hintSfsemiboldblacktext(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text(
                                                  'Cancel',
                                                  style: TextStyle(color: red),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              new FlatButton(
                                                child: isCardDelete
                                                    ? Image.asset(
                                                        'lib/assets/images/spinner.gif',
                                                        width: 10.0,
                                                        height: 10.0,
                                                        color: Colors.black,
                                                      )
                                                    : Text(
                                                        'Ok',
                                                        style:
                                                            textBarlowRegularBlack(),
                                                      ),
                                                onPressed: () {
                                                  deleteCard(
                                                      cardList[index]['_id']);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Text(
                              '************${cardList[index]['lastFourDigits']}',
                              style: textBarlowRegularWhite(),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Card holder',
                                      style: textbarlowmediumwhitedull(),
                                    ),
                                    Text(
                                      '${cardList[index]['cardHolderName']}',
                                      style: textbarlowmediumwhite(),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'Expires',
                                      style: textbarlowmediumwhitedull(),
                                    ),
                                    Text(
                                      '${cardList[index]['expiryMonth']}/${cardList[index]['expiryYear']}',
                                      style: textbarlowmediumwhite(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              InkWell(
                onTap: () {
                  var result = Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new AddCard(),
                    ),
                  );

                  if (result != null) {
                    result.then((onValue) {
                      fetchCardInfo();
                      if (mounted) {
                        setState(() {
                          cardList = cardList;
                        });
                      }
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 15.0),
                  height: 141,
                  width: 232,
                  decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      border: Border.all(color: Color(0xFFD3D3D3), width: 1),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Add new card',
                        style: textBarlowRegularBlack(),
                      )
                    ],
                  ),
                ),
              )
            ],
          );

    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  elevation: 0,
                  title: Text(
                    'Profile',
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: primary,
                  automaticallyImplyLeading: false,
                ),
      body: isGetTokenLoading
          ? SquareLoader()
          : token == null
              ? Login()
              : isCardListLoading
                  ? SquareLoader()
                  : isLoading
                      ? SquareLoader()
                      : ListView(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfile(userInfo: userInfo),
                                  ),
                                );
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
                                          child: userInfo == null ||
                                                  userInfo['profilePic'] == null
                                              ? Center(
                                                  child: new Container(
                                                    width: 200.0,
                                                    height: 200.0,
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              27.0),
                                                      image:
                                                          new DecorationImage(
                                                        fit: BoxFit.fill,
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
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      image:
                                                          new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            userInfo[
                                                                'profilePic']),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: .0, bottom: 6.0),
                                            child: userInfo == null &&
                                                    userInfo['firstName'] ==
                                                        null &&
                                                    userInfo['lastName'] == null
                                                ? Text(
                                                    '',
                                                    style:
                                                        textBarlowMediumBlack(),
                                                  )
                                                : Text(
                                                    '${userInfo['firstName']} ${userInfo['lastName'] == null ? "" : userInfo['lastName']}',
                                                    style:
                                                        textBarlowMediumBlack(),
                                                  ),
                                          ),
                                          SizedBox(height: 6),
                                          userInfo == null &&
                                                  userInfo['email'] == null
                                              ? Text(
                                                  '',
                                                  style: textbarlowmedium(),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${userInfo['email']}',
                                                      style: textbarlowmedium(),
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(height: 6),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, right: .0),
                                            child: userInfo == null &&
                                                    userInfo['mobileNumber'] ==
                                                        null
                                                ? Text(
                                                    '',
                                                    style: textbarlowmedium(),
                                                  )
                                                : Text(
                                                    '${userInfo['mobileNumber'] == null ? "" : userInfo['mobileNumber']}',
                                                    style: textbarlowmedium(),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
//                                      fit: FlexFit.tight,
//                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 45),
//                                                child:SvgPicture.asset('lib/assets/icons/editt.svg')
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0, left: 20.0),
                                  child: Text(
                                    'Saved cards',
                                    style: textBarlowMediumBlack(),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                              ),
                              child: Container(
                                height: 160,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: isCardListLoading
                                                ? Image.asset(
                                                    'lib/assets/images/spinner.gif',
                                                    width: 10.0,
                                                    height: 10.0,
                                                    color: Colors.black,
                                                  )
                                                : itemCard,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Address()),
                                );
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
                                          top: 10.0, bottom: 10.0, left: 20.0),
                                      child: Text(
                                        'Address',
                                        style: textBarlowMediumBlack(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Orders(
                                      userID: userID,
                                    ),
                                  ),
                                );
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
                                          top: 10.0, bottom: 10.0, left: 20.0),
                                      child: Text(
                                        'Order History',
                                        style: textBarlowMediumBlack(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Chat(),
                                  ),
                                );
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
                                          top: 10.0, bottom: 10.0, left: 20.0),
                                      child: Text(
                                        'Chat',
                                        style: textBarlowMediumBlack(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () {
                                logout();
                              },
                              child: Container(
                                height: 55,
                                padding: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF7F7F7),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                            left: 20.0,
                                            right: 20),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Log out',
                                              style: textBarlowMediumBlack(),
                                            ),
                                          ],
                                        )),
                                    Row(
                                      children: <Widget>[
                                        logoutLoading
                                            ? Image.asset(
                                                'lib/assets/images/spinner.gif',
                                                width: 10.0,
                                                height: 10.0,
                                                color: Colors.black,
                                              )
                                            : SvgPicture.asset(
                                                'lib/assets/icons/lgout.svg')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30)
                          ],
                        ),
    );
  }
}
