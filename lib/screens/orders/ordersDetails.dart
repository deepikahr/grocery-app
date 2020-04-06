import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class OrderDetails extends StatefulWidget {
  final String orderId;
  OrderDetails({Key key, this.orderId}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isLoading = false;
  var orderHistory;
  String currency;
  double rating;

  @override
  void initState() {
    getOrderHistory();
    super.initState();
  }

  getOrderHistory() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    print(widget.orderId);
    await LoginService.getOrderHistory(widget.orderId).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              orderHistory = onValue['response_data'];
              print(orderHistory["ratings"]);

              isLoading = false;
            });
          }
        } else {}
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  ratingAlert(orderId, userId, productID) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            margin: const EdgeInsets.only(
                top: 250.0, bottom: 170.0, left: 20.0, right: 20.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(
                new Radius.circular(32.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Text(
                    'Rate Product',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        decoration: TextDecoration.none),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RatingBar(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 30.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 15.0,
                        ),
                        onRatingUpdate: (rate) {
                          setState(() {
                            rating = rate;
                            print(rate);
                          });
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50),
                Center(
                  child: GFButton(
                    onPressed: () {
                      if (rating == null) {
                        rating = 3.0;
                      }
                      orderRating(orderId, rating, productID);
                    },
                    text: 'Submit',
                    textColor: Colors.black,
                    color: primary,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  orderRating(orderId, rating, productID) async {
    var body = {"rate": rating, "order": orderId, "productId": productID};
    print(body);
    print(orderId);

    await ProductService.productRate(body).then((onValue) {
      print(onValue);
      try {
        if (onValue['response_code'] == 201) {
          Navigator.pop(context);
          getOrderHistory();
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text(
          'Order Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Order ID:', style: titleBold()),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 8),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(orderHistory['_id'],
                                style: subtitleBold()),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Delivery Date:', style: titleBold()),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(orderHistory['deliveryDate'],
                                style: subtitleBold()),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Delivery Time:', style: titleBold()),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(orderHistory['deliveryTime'],
                                style: subtitleBold()),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Payment Type:', style: titleBold()),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(orderHistory['paymentType'],
                                style: subtitleBold()),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Order Status:', style: titleBold()),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(orderHistory['orderStatus'],
                                style: subtitleBold()),
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
                    style: titleBold(),
                  ),
                ),
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderHistory['cart']['cart'].length == null
                      ? 0
                      : orderHistory['cart']['cart'].length,
                  itemBuilder: (BuildContext context, int i) {
                    print(orderHistory);
                    return Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white38,
                          child: GFListTile(
                            avatar: Container(
                              width: 60,
                              child: Image.network(
                                  orderHistory['cart']['cart'][i]['imageUrl']),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 0.0, right: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6.0),
                                        child: Text(
                                          orderHistory['cart']['cart'][i]
                                              ['title'],
                                          style: titleBold(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            orderHistory['cart']['cart'][i]
                                                ['description'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 3.0,
                                      bottom: 2.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(currency),
                                        Text(
                                          orderHistory['cart']['cart'][i]
                                                  ['price']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        orderHistory['cart']['cart'][i]
                                                ['unit'] +
                                            " * " +
                                            orderHistory['cart']['cart'][i]
                                                    ['quantity']
                                                .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0),
                                      ),
                                      orderHistory['orderStatus'] == "DELIVERED"
                                          ? orderHistory['cart']['cart'][i]
                                                      ['rating'] ==
                                                  null
                                              ? GFButton(
                                                  shape: GFButtonShape.pills,
                                                  onPressed: () {
                                                    print(orderHistory['_id']);
                                                    print(orderHistory['user']
                                                        ['_id']);
                                                    print(orderHistory['cart']
                                                            ['cart'][i]
                                                        ['productId']);
                                                    ratingAlert(
                                                        orderHistory['_id'],
                                                        orderHistory['user']
                                                            ['_id'],
                                                        orderHistory['cart']
                                                                ['cart'][i]
                                                            ['productId']);
                                                  },
                                                  color: primary,
                                                  text: 'Rate',
                                                )
                                              : GFButton(
                                                  onPressed: null,
                                                  shape: GFButtonShape.pills,
                                                  color: primary,
                                                  text: orderHistory['cart']
                                                                  ['cart'][i]
                                                              ['rating']
                                                          .toString() +
                                                      " Star",
                                                )
                                          : Container()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
                          Text('Sub Total:', style: titleBold()),
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
                                  Text(
                                    currency,
                                    style: titleBold(),
                                  ),
                                  Text(
                                    orderHistory['subTotal'].toString(),
                                    style: titleBold(),
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
                          Text('Tax:', style: titleBold()),
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
                                  Text(
                                    currency,
                                    style: titleBold(),
                                  ),
                                  Text(
                                    orderHistory['tax'].toString(),
                                    style: titleBold(),
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
                          Text('Delivery Charges:', style: titleBold()),
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
                                  Text(
                                    currency,
                                    style: titleBold(),
                                  ),
                                  Text(
                                    orderHistory['deliveryCharges'].toString(),
                                    style: titleBold(),
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
                      Text('Grand Total:', style: titleBold()),
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
                              Text(
                                currency,
                                style: titleBold(),
                              ),
                              Text(
                                orderHistory['grandTotal'].toString(),
                                style: titleBold(),
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
    );
  }
}
