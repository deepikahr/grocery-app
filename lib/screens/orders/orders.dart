import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:intl/intl.dart';
// import '../screens/home.dart';

SentryError sentryError = new SentryError();

class Orders extends StatefulWidget {
  final String userID;
  Orders({Key key, this.userID}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool isLoading = false;
  bool isLoadingSubProductsList = false;
  List subProductsList = List();
  List<dynamic> orderList;
  var orderedTime;

  @override
  void initState() {
    super.initState();
    getOrderByUserID();
    // orderedTime = orderList[0]['deliveryTime'];
    // print(orderList[0]['deliveryTime']);
    // orderedTime = new DateTime.now();
    // print(new DateFormat("yMd").format(orderedTime));
  }

  // dateConvertor(date) {
  //   print('I am here');
  //   var parsedDate = DateTime.parse(date);
  //   orderedTime = new DateFormat("yMd").format(parsedDate);
  //   print(orderedTime);
  //   return orderedTime;
  // }

  getOrderByUserID() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await ProductService.getOrderByUserID(widget.userID).then((onValue) {
      // print('getOrderByUserID $onValue');
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              orderList = onValue['response_data'];
              // print(orderList[0]['grandTotal']);
              // print('orderList at profile $orderList');
            });
          }
        } else {
          // print('Failure');
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text(
          'Orders',
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
      body: ListView(
        children: <Widget>[
          orderList.length == 0
              ? Center(child: Image.asset('lib/assets/images/no-orders.png'))
              : SizedBox(height: 20),
          Container(
            color: Colors.white38,
            child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: orderList.length == null ? 0 : orderList.length,
              itemBuilder: (BuildContext context, int i) {
                return GFListTile(
                  avatar: Container(
                    height: 100,
                    width: 100,
                    child: orderList[i]['cart']['cart'][0]['imageUrl'] == null
                        ? Image.asset('lib/assets/images/no-orders.png')
                        : Image.network(
                            orderList[i]['cart']['cart'][0]['imageUrl'],
                          ),
                  ),
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
                              child: orderList[i]['cart']['cart'][0]['title'] ==
                                      null
                                  ? " "
                                  : Text(
                                      orderList[i]['cart']['cart'][0]['title'],
                                      style: titleBold(),
                                    ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: orderList[i]['cart']['cart'][0]
                                          ['discription'] ==
                                      null
                                  ? " "
                                  : Text(
                                      orderList[i]['cart']['cart'][0]
                                          ['discription'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14.0),
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
                              orderList[i]['grandTotal'] == null
                                  ? " "
                                  : Text(orderList[i]['grandTotal'].toString()),
                              // Text('4566')
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                'Ordered At : ' +
                                    DateFormat('dd/MM/yyyy hh:mm a').format(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            orderList[i]['deliveryDate'])),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 11.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // showDivider: false,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 15),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Order Confirmed',
                      style: TextStyle(color: Colors.green),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 58.0, top: 3.0),
                      child: Text(
                        '4.30 pm',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 38.0),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 15),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Out for delivery',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 58.0, top: 3.0),
                      child: Text(
                        '4.30 pm',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 15),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Order Delivered',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 58.0, top: 3.0),
                      child: Text(
                        '4.30 pm',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
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
                            style: titleBold(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Blended scotch whiskey',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14.0),
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
                          Text('4566')
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outline,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          'Delivered : 02/02/2020 4.30 pm',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 11.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // showDivider: false,
            ),
          ),
          Container(
            color: Colors.white38,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: GFButton(
                      onPressed: () {},
                      text: 'ReOrder',
                      color: primary,
                      // size: GFSize.small,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: GFButton(
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
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: Text(
                                          'Rate Product',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: RatingBar(
                                              initialRating: 3,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              // itemCount: 5,
                                              itemSize: 30.0,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.red,
                                                size: 15.0,
                                              ),
                                              onRatingUpdate: (rating) {
                                                // print(rating);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 28.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(32),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    32))),
                                                height: 70,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 110.0,
                                                          right: 110.0,
                                                          top: 15,
                                                          bottom: 15),
                                                  child: GFButton(
                                                    onPressed: () {},
                                                    text: 'Submit',
                                                    textColor: Colors.black,
                                                    color: primary,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )

                                      //   children: <Widget>[
                                      //     // Expanded(
                                      //     Padding(
                                      //       padding:
                                      //           const EdgeInsets.only(top: 43.0),
                                      //       child: Container(
                                      //         padding: EdgeInsets.only(),
                                      //         height: 80,
                                      //         decoration: BoxDecoration(
                                      //             color: Colors.black,
                                      //             borderRadius: BorderRadius.only(
                                      //                 bottomLeft:
                                      //                     Radius.circular(32),
                                      //                 bottomRight:
                                      //                     Radius.circular(32))),
                                      //       ),
                                      //     ),
                                      //     // )
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      text: 'Rate',
                      color: primary,
                      type: GFButtonType.outline,
                      size: GFSize.small,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
