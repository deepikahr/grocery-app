import 'package:flutter/material.dart';
import 'package:getflutter/components/alert/gf_alert.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/screens/login/login.dart';
// import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/fav-service.dart';

SentryError sentryError = new SentryError();

class SavedItems extends StatefulWidget {
  @override
  _SavedItemsState createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  bool isGetTokenLoading = false;
  bool isFavListLoading = false;
  List<dynamic> favProductList;
  @override
  void initState() {
    super.initState();
    getToken();
    getFavListApi();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFavListApi() async {
    await FavouriteService.getFavList().then((onValue) {
      if (onValue != null) {
        setState(() {
          isFavListLoading = true;
        });
        favProductList = onValue['response_data'];
        print('I am here');
        print(favProductList);
      } else {
        setState(() {
          isFavListLoading = false;
        });
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getToken() async {
    await Common.getToken().then((onValue) {
      // print("i am here");
      // print(onValue);
      if (onValue != null) {
        setState(() {
          isGetTokenLoading = true;
        });
      } else {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      // checkToken(onValue);
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget itemCard = GFCard(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      boxFit: BoxFit.cover,
      colorFilter: new ColorFilter.mode(
          Colors.black.withOpacity(0.67), BlendMode.darken),
      content: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Image.asset(
                      'lib/assets/images/apple.png',
                      // width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitHeight,

                      width: 80,
                      height: 80,
                    ),
                  ),
                  Positioned(
                    height: 18.0,
                    width: 60.0,
                    top: 0.0,
                    left: 0.0,
                    child: GFButtonBadge(
                      // icon: GFBadge(
                      //   // text: '6',
                      //   shape: GFBadgeShape.pills,
                      // ),
                      // fullWidthButton: true,
                      onPressed: () {},
                      text: '25% off',
                      color: Colors.deepOrange[300],
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text('Apple'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0, top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          IconData(
                            0xe913,
                            fontFamily: 'icomoon',
                          ),
                          color: const Color(0xFF00BFA5),
                          size: 11.0,
                        ),
                        Text(
                          '85/kg',
                          style: TextStyle(color: const Color(0xFF00BFA5)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 38.0, bottom: 15.0),
                    child: GFIconButton(
                      onPressed: null,
                      icon: GestureDetector(
                        onTap: () {
                          setState(() {
                            fav = !fav;
                          });
                        },
                        child: fav
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.grey,
                              ),
                      ),
                      type: GFButtonType.transparent,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );

    return Scaffold(
        appBar: GFAppBar(
          title: Text('Saved Items',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: isGetTokenLoading
              ? Colors.transparent
              : Colors.black.withOpacity(0.3),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black, size: 1.0),
        ),
        body: GFFloatingWidget(
          showblurness: isGetTokenLoading ? false : true,
          blurnessColor:
              isGetTokenLoading ? Colors.white : Colors.black.withOpacity(0.3),
          verticalPosition: 70,
          child: isGetTokenLoading
              ? Container(
                  height: 800.0,
                  child: GridView.builder(
                    itemCount: 8,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(child: itemCard);
                    },
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
                                border:
                                    Border.all(color: Colors.black, width: 1),
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
                                            isStore: true,
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
        ));
  }
}
