import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/badge/gf_badge.dart';
import 'package:getflutter/components/badge/gf_button_badge.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/components/card/gf_card.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/components/tabs/gf_tabBar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/tabs/gf_tabBarView.dart';
import 'package:getflutter/components/tabs/gf_segment_tabs.dart';
import 'package:grocery_pro/screens/home/store.dart';
import 'package:grocery_pro/style/style.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          title: Text('My Cart',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // iconTheme: IconThemeData(color: Colors.black, size: 15.0),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey[100],
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '2 items',
                          style: comments(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white54,
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Image.asset('lib/assets/images/cherry.png'),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: Text(
                              'Cherry',
                              style: heading(),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 30.0),
                            child: Text(
                              '100% Organic',
                              style: labelStyle(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: Row(
                              children: <Widget>[
                                Image.asset('lib/assets/icons/rupee.png'),
                                Text(
                                  ' 85/kg',
                                  style: TextStyle(
                                      color: const Color(0xFF00BFA5),
                                      fontSize: 17.0),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 78.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20.0)),
                          height: 100,
                          width: 30,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Icon(Icons.add
                                    // IconData(
                                    //   0xe910,
                                    //   fontFamily: 'icomoon',
                                    // ),
                                    // color: getGFColor(GFColor.white),
                                    ),
                              ),
                              // Text(''),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: Container(child: Text('1')),
                              ),
                              // Text(''),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Icon(
                                    Icons.remove, color: Colors.white,
                                    // IconData(
                                    //   0xe910,
                                    //   fontFamily: 'icomoon',
                                    // ),
                                    // color: getGFColor(GFColor.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  color: Colors.white54,
                  child: Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  // height: 150,
                                  // width: 130,
                                  child: Image.asset(
                                      'lib/assets/images/apple.png')),
                            ],
                          ),
                          Positioned(
                            height: 26.0,
                            width: 117.0,
                            top: 77.0,
                            // left: 20.0,
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
                      // Column(
                      //   children: <Widget>[
                      //     Image.asset('lib/assets/images/grape.png'),
                      //   ],
                      // ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: Text(
                              'Applee',
                              style: heading(),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 30.0),
                            child: Text(
                              '100% Organic',
                              style: labelStyle(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: Row(
                              children: <Widget>[
                                Image.asset('lib/assets/icons/rupee.png'),
                                Text(
                                  ' 85/kg',
                                  style: TextStyle(
                                      color: const Color(0xFF00BFA5),
                                      fontSize: 17.0),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 78.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20.0)),
                          height: 100,
                          width: 30,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Icon(Icons.add
                                    // IconData(
                                    //   0xe910,
                                    //   fontFamily: 'icomoon',
                                    // ),
                                    // color: getGFColor(GFColor.white),
                                    ),
                              ),
                              // Text(''),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: Container(child: Text('1')),
                              ),
                              // Text(''),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Icon(
                                    Icons.remove, color: Colors.white,
                                    // IconData(
                                    //   0xe910,
                                    //   fontFamily: 'icomoon',
                                    // ),
                                    // color: getGFColor(GFColor.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 1.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 115.0,
                        height: 45.0,
                        child: GFButton(
                          onPressed: () {},
                          // text: 'Warning',
                          color: GFColor.dark,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text('SubTotal:'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Icon(
                                        Icons.attach_money,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: Text(
                                        '123',
                                        // style: TextStyle(color: const Color(0xFF00BFA5)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 215.0,
                        height: 45.0,
                        child: GFButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Checkout',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 20.0,
                              )
                            ],
                          ),
                          color: GFColor.warning,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
