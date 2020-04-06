import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/chat/chatpage.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/screens/orders/orders.dart';
import 'package:grocery_pro/screens/address/address.dart';
import 'package:grocery_pro/screens/payment/addCard.dart';
import 'package:grocery_pro/screens/tab/editprofile.dart';
import 'package:grocery_pro/service/payment-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/auth-service.dart';

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
    await PaymentService.getCardList().then((onValue) {
      if (mounted) {
        setState(() {
          cardList = onValue['response_data'];
          isCardListLoading = false;
          getUserInfo();
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

  getUserInfo() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await LoginService.getUserInfo().then((onValue) {
      print(onValue);
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Home(),
          ),
        );
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
                  ));

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
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 141,
                      width: 232,
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Color(0xFF5FB8E5),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 38.0, top: 20.0),
                                child: cardList[index]['cardImage'] == null
                                    ? Image.asset(
                                        'lib/assets/icons/mastercard-logo.png')
                                    : Image.network(
                                        '${cardList[index]['cardImage']}',
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  '${cardList[index]['bank']}',
                                  style: textBarlowRegularWhite(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                '************${cardList[index]['lastFourDigits']}',
                                style: textBarlowRegularWhite(),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Card holder',
                                    style: textBarlowRegularWhit(),
                                  ),
                                  Text(
                                    '${cardList[index]['cardHolderName']}',
                                    style: textBarlowRegularWhit(),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Expires',
                                    style: textBarlowRegularWhit(),
                                  ),
                                  Text(
                                    '${cardList[index]['expiryMonth']}/${cardList[index]['expiryYear']}',
                                    style: textBarlowRegularWhit(),
                                  ),
                                ],
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
                                            style: textBarlowRegularBlack(),
                                          ),
                                          content: new SingleChildScrollView(
                                            child: new ListBody(
                                              children: <Widget>[
                                                new Text(
                                                  'Delete Card',
                                                  style:
                                                      textBarlowRegularBlack(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            new FlatButton(
                                              child: new Text('Cancel'),
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
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
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
            ],
          );

    return Scaffold(
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  title: Text(
                    'Profile',
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: primary,
                  automaticallyImplyLeading: false,
                ),
      body: isGetTokenLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : token == null
              ? Login()
              : isCardListLoading
                  ? Center(child: CircularProgressIndicator())
                  : isLoading
                      ? Center(child: CircularProgressIndicator())
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
                                padding: const EdgeInsets.only(left: 15.0),
                                width: 232,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 80.0,
                                        child: userInfo == null ||
                                                userInfo['profilePic'] == null
                                            ? Center(
                                                child: new Container(
                                                  width: 200.0,
                                                  height: 200.0,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    image: new DecorationImage(
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
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    image: new DecorationImage(
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: .0, bottom: 4.0),
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
                                        userInfo == null &&
                                                userInfo['email'] == null
                                            ? Text(
                                                '',
                                                style: textBarlowRegularBlack(),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    '${userInfo['email']}',
                                                    style:
                                                        textBarlowRegularBlack(),
                                                  ),
                                                ],
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, right: .0),
                                          child: userInfo == null &&
                                                  userInfo['mobileNumber'] ==
                                                      null
                                              ? Text(
                                                  '',
                                                  style:
                                                      textBarlowRegularBlack(),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${userInfo['mobileNumber'] == null ? "" : userInfo['mobileNumber']}',
                                                      style:
                                                          textBarlowRegularBlack(),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                color: Colors.white38,
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
                                color: Colors.white38,
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
                                color: Colors.white38,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0, left: 20.0),
                                      child: Text(
                                        'Support',
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
                            Container(
                              color: Colors.white38,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0, left: 20.0),
                                    child: InkWell(
                                      onTap: () {
                                        logout();
                                      },
                                      child: Text(
                                        'Logout',
                                        style: textBarlowMediumBlack(),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 248.0),
                                        child: logoutLoading
                                            ? Image.asset(
                                                'lib/assets/images/spinner.gif',
                                                width: 10.0,
                                                height: 10.0,
                                                color: Colors.black,
                                              )
                                            : Icon(Icons.exit_to_app),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30)
                          ],
                        ),
    );
  }
}
