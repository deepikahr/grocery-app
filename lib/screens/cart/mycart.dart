import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/badge/gf_button_badge.dart';

import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/shape/gf_button_shape.dart';
import 'package:grocery_pro/screens/checkout/checkout.dart';

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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
                          child: Image.asset('lib/assets/images/cherry.png'),
                        ),
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
                                    borderRadius: BorderRadius.circular(20.0)),
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
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 6.0, top: 6.0),
                              child: Image.asset('lib/assets/images/apple.png'),
                            )),
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
                                    borderRadius: BorderRadius.circular(20.0)),
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
              // SizedBox(
              //   height: 150.0,
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 15.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 105.0,
                    height: 45.0,
                    child: GFButton(
                      onPressed: () {},
                      // text: 'Warning',
                      color: GFColor.dark,
                      shape: GFButtonShape.square,

                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text('Grand Total :'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    IconData(
                                      0xe913,
                                      fontFamily: 'icomoon',
                                    ),
                                    color: Colors.white,
                                    size: 11.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
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
                    width: 210.0,
                    height: 45.0,
                    child: GFButton(
                      onPressed: () {},
                      shape: GFButtonShape.square,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Add to cart ',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            IconData(
                              0xe911,
                              fontFamily: 'icomoon',
                            ),
                            // color: const Color(0xFF00BFA5),
                            // size: 1.0,
                          ),
                        ],
                      ),
                      color: GFColor.warning,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
