import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text(
          'Order Details',
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Order ID:', style: textBarlowMediumBlack()),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 8),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text('12342435262735482528152825',
                          style: textBarlowMediumBlack()),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Delivery Date:', style: textBarlowMediumBlack()),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text('11/12/1234', style: textBarlowMediumBlack()),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Delivery Time:', style: textBarlowMediumBlack()),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text('12.30', style: textBarlowMediumBlack()),
                          Text('PM', style: textBarlowMediumBlack()),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Payment Type:', style: textBarlowMediumBlack()),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text('COD', style: textBarlowMediumBlack()),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Order Status:', style: textBarlowMediumBlack()),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text('Delivered', style: textBarlowMediumGreen()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Items List',
              style: textBarlowMediumBlack(),
            ),
          ),
          Container(
            color: Colors.white38,
            child: GFListTile(
              avatar: Container(
                  // width: 150,
                  child: Image.asset('lib/assets/images/orange.png')),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 18.0, right: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            'White walker',
                            style: textBarlowMediumBlack(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.41,
                            child: Text(
                              'Blended scotch whiskey Blended scotch whiskey',
                              style: textBarlowRegularBlack(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            IconData(
                              0xe913,
                              fontFamily: 'icomoon',
                            ),
                            color: Colors.black,
                            size: 11.0,
                          ),
                          Text(
                            '4566',
                            style: textBarlowBoldBlack(),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Icon(
                        //   Icons.check_circle_outline,
                        //   size: 15,
                        //   color: Colors.grey,
                        // ),
                        Text(
                          '1kg',
                          style: textBarlowMediumBlack(),
                        ),
                        GFButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 250.0,
                                          bottom: 170.0,
                                          left: 20.0,
                                          right: 20.0),
                                      // width: 130.0,
                                      // height: 40.0,
                                      decoration: new BoxDecoration(
                                        // shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(32.0)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25.0),
                                            child: Text(
                                              'Rate Product',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: RatingBar(
                                                  initialRating: 3,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  // itemCount: 5,
                                                  itemSize: 30.0,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.red,
                                                    size: 15.0,
                                                  ),
                                                  onRatingUpdate: (rating) {},
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 50),
                                          Center(
                                            child: GFButton(
                                              onPressed: () {},
                                              text: 'Submit',
                                              textColor: Colors.black,
                                              color: primary,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          color: primary,
                          text: 'Rate',
                          textStyle: textBarlowRegularWhite(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey[300],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Sub Total:', style: textBarlowMediumBlack()),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          bottom: 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe913,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 12.0,
                            ),
                            Text(
                              '4566',
                              style: textBarlowBoldBlack(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Tax:', style: textBarlowMediumBlack()),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          bottom: 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe913,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 12.0,
                            ),
                            Text(
                              '4566',
                              style: textBarlowBoldBlack(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Delivery Charges:', style: textBarlowMediumBlack()),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          bottom: 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe913,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 12.0,
                            ),
                            Text(
                              '4566',
                              style: textBarlowBoldBlack(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Grand Total:', style: textBarlowMediumBlack()),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          IconData(
                            0xe913,
                            fontFamily: 'icomoon',
                          ),
                          color: Colors.black,
                          size: 12.0,
                        ),
                        Text(
                          '4566',
                          style: textBarlowBoldBlack(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
          child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: GFButton(
                onPressed: () {},
                text: 'ReOrder',
                textStyle: textBarlowRegularWhite(),
                color: primary,
                size: GFSize.SMALL,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: GFButton(
                onPressed: () {},
                text: 'Rate',
                textStyle: textbarlowRegularaPrimary(),
                type: GFButtonType.outline,
                color: primary,
                size: GFSize.SMALL,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
