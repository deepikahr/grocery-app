import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/orders/orders.dart';
import 'package:grocery_pro/screens/address/address.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/screens/profile/editprofile.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/main.dart';
import 'package:getflutter/components/alert/gf_alert.dart';
import 'package:grocery_pro/screens/login/login.dart';
import 'package:grocery_pro/service/auth-service.dart';

SentryError sentryError = new SentryError();

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userInfo;
  bool isLoading = false;
  bool isGetTokenLoading = false;
  bool isProfile = true;
  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    await Common.getToken().then((onValue) {
      print('Token at the profile');
      print(onValue);
      if (onValue != null) {
        setState(() {
          isGetTokenLoading = true;
          getUserInfo();
        });
      } else {
        setState(() {
          isGetTokenLoading = false;
        });
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
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
            print('userData at profile');
            print(userInfo);
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
    Common.setToken(null).then((onValue) async {
      print('logout ');
      print(onValue);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          // prefs.setString('selectedLanguage', null);
        });
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyApp(),
          ),
          (Route<dynamic> route) => true);
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget itemCard = Container(
      padding: const EdgeInsets.only(right: 15.0,left: 15.0),
      height: 141,
      width: 232,
      decoration: BoxDecoration(
          color: Colors.blue[400], borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 38.0, top: 20.0),
                child: Image.asset('lib/assets/icons/mastercard-logo.png'),
              )
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                '3421 **** **** **34',
                style: TextStyle(fontSize: 19.0, color: Colors.white),
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
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                  Text(
                    'Billie Eilsh',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Expires',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                  Text(
                    '12/12',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
     Widget addCard = Container(
      padding: const EdgeInsets.only(left: 15.0),
      height: 141,
      width: 232,
      decoration: BoxDecoration(
          color: Colors.grey[400], borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      Icon(Icons.add,size: 40,color: Colors.black54,),
      SizedBox(height:5),
      Text('Add new card',style: TextStyle(color: Colors.black54),)
        ],
      ),
    );
    return Scaffold(
      appBar: GFAppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor:
            isGetTokenLoading ? primary : Colors.black.withOpacity(0.0),
        automaticallyImplyLeading: false,
      ),
      body: GFFloatingWidget(
        showblurness: isGetTokenLoading ? false : true,
        blurnessColor:
            isGetTokenLoading ? Colors.white : Colors.black.withOpacity(0.3),
        // verticalPosition: 70,
        child: isGetTokenLoading
            ? isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white38,
                            child: GFListTile(
                                avatar: Image.asset(
                                    'lib/assets/images/profile.png'),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: .0, bottom: 4.0),
                                          child: userInfo == null &&
                                                  userInfo['firstName'] == null
                                              ? Text(
                                                  'Billie Eilsh',
                                                  style: titleBold(),
                                                )
                                              : Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      '${userInfo['firstName']}',
                                                      style: titleBold(),
                                                    ),
                                                ],
                                              )),
                                      userInfo == null &&
                                              userInfo['email'] == null
                                          ? Text(
                                              'badguy@email.com',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14.0),
                                            )
                                          : Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  '${userInfo['email']}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 14.0),
                                                ),
                                            ],
                                          ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, right: .0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('+91-9756 55 83 13'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subTitle: Container(),
                                description: Container(),
                                icon: Padding(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfile()),
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: primary,
                                      ),
                                    ))
                                // showDivider: false,
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
                                  style: titleBold(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Container(
                              height: 150,
                              // width: 50,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 1,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Container(
                                    // height: 50,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right:15.0),
                                          child: itemCard,
                                        ),
                                        addCard,
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
                                      style: titleBold(),
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
                                    builder: (context) => Orders()),
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
                                      style: titleBold(),
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
                                  child: Text(
                                    'Help',
                                    style: titleBold(),
                                  ),
                                ),
                              ],
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => logout()),
                                        );
                                      },
                                      child: Text(
                                        'Logout',
                                        style: titleBold(),
                                      ),
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 248.0),
                                      child: Icon(Icons.exit_to_app),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
            : GFAlert(
                title: 'Login First!',
                bottombar: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          height: 40.0,
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                              color: primary,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                              child: new FlatButton(
                            child: new Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login(
                                          isProfile: true,
                                        )),
                              );
                            },
                          ))),
                      // Container(
                      //     height: 40.0,
                      //     padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      //     decoration: BoxDecoration(
                      //         color: primary,
                      //         border:
                      //             Border.all(color: Colors.black, width: 1),
                      //         borderRadius: BorderRadius.circular(5.0)),
                      //     child: new FlatButton(
                      //         child: new Text(
                      //           'Cancel',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         onPressed: () async {
                      //           // Navigator.push(
                      //           //   context,
                      //           //   MaterialPageRoute(
                      //           //       builder: (context) => Otp()),
                      //           // );
                      //         })),
                    ]),
              ),
      ),
    );
  }
}
