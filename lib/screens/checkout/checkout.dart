import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text('Checkout',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Cart summary', style: boldHeading()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Sub total ( 2 items )',
                      style: regular(),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 170.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            IconData(
                              0xe913,
                              fontFamily: 'icomoon',
                            ),
                            color: Colors.black,
                            size: 10.0,
                          ),
                          Text(
                            '123',
                            style: regular(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Discount',
                      style: regular(),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 230.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            IconData(
                              0xe913,
                              fontFamily: 'icomoon',
                            ),
                            color: Colors.black,
                            size: 10.0,
                          ),
                          Text(
                            '123',
                            style: regular(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Delivery charges',
                      style: regular(),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 187.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            IconData(
                              0xe913,
                              fontFamily: 'icomoon',
                            ),
                            color: Colors.black,
                            size: 10.0,
                          ),
                          Text(
                            '123',
                            style: regular(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                GFButton(
                  onPressed: null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Text(
                      " Enter Coupon code ",
                    ),
                  ),
                  type: GFButtonType.outline,
                  color: GFColor.dark,
                  size: GFSize.medium,
                  // blockButton: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GFButton(
                    onPressed: null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "Apply ",
                      ),
                    ),
                    color: GFColor.warning,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: Container(
              // color: Colors.grey[100],
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black,
                    // blurRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 22.0, top: 10.0, bottom: 10.0),
                        child: Text(
                          'Total',
                          style: titleBold(),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 250.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe913,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 10.0,
                            ),
                            Text(
                              '',
                              style: boldHeading(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: Text('Delivery type', style: boldHeading()),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Payment type', style: boldHeading()),
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 10.0),
                    child: Image.asset('lib/assets/images/mastercard.png'),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text('7034xxxx xxxx xxxx'),
                  Text('cvv'),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: GFButton(
              // color: primary,

              color: GFColor.warning,

              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Otp()),
                // );
              },
              text: 'Submit',
              textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
