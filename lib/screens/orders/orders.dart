import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/orders/ordersDetails.dart';
import 'package:grocery_pro/screens/tab/mycart.dart';
import 'package:grocery_pro/service/cart-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/style.dart';

SentryError sentryError = new SentryError();

class Orders extends StatefulWidget {
  final String userID;
  Orders({Key key, this.userID}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool isLoading = false, isLoadingSubProductsList = false;
  List subProductsList = List();
  List<dynamic> orderList;
  bool showRating= false;
  bool showblur = false;
  double _rating = 3;
  var orderedTime;
  double rating;
  String currency;
  @override
  void initState() {
    getOrderByUserID();
    super.initState();
  }

  getOrderByUserID() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await ProductService.getOrderByUserID(widget.userID).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              orderList = onValue['response_data'];
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

  addToCart(data, length, loopIndex) async {
    Map<String, dynamic> buyNowProduct = {
      'productId': data['productId'].toString(),
      'quantity': data['quantity'],
      "price": data['price'],
      "unit": data['unit']
    };

    await CartService.addProductToCart(buyNowProduct).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (length - 1 == loopIndex) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MyCart(),
              ),
            );
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  orderRating(orderId, rating) async {
    var body = {"rating": rating};
    print(body);
    print(orderId);

    await ProductService.orderRating(body, orderId).then((onValue) {
      print(onValue);
      try {
        if (onValue['response_code'] == 200) {
          Navigator.pop(context);
          getOrderByUserID();
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  ratingAlert(orderId) {
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
                      orderRating(orderId, rating);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text(
          'Orders',
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body:
      GFFloatingWidget(
        verticalPosition:MediaQuery.of(context).size.height* 0.3,
        blurnessColor: Colors.black.withOpacity(0.33),
        showblurness: showblur,
        child: showRating?GFAlert(

          type: GFAlertType.rounded,
          alignment: Alignment.center,
          backgroundColor: Colors.white,
          child: Text('Rate Product', style: textbarlowmediumwred(),),
          contentChild:  Column(
            children: <Widget>[
              GFRating(
                color: GFColors.SUCCESS,
                borderColor: GFColors.SUCCESS,
                value: _rating,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
            ],
          ),
          bottombar:Container(
//            height: 48,
alignment: Alignment.center,
            child:  GFButton(
              padding: EdgeInsets.only(left:20, right:20),
              onPressed: () {
                setState(() {
                  showRating = false;
                  showblur=false;

                });
              },
              fullWidthButton: false,
              color: primary,
              text: 'Submit',
              textStyle: textbarlowmediumwblack(),
            ),
          )
        ):Container(),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : orderList.length == 0
                ? Center(
                    child: Image.asset('lib/assets/images/no-orders.png'),
                  )
                : ListView(
                    children: <Widget>[
                    Container(
margin: EdgeInsets.only(top:20, bottom:10),
                      decoration: BoxDecoration(
                          color: Color(0xFFFDFDFD),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 6
                          )
                        ]
                      ),
                      child: Column(
                        children: <Widget>[
                          product(),
                          orderTrack(),
                        ],
                      ),
                    ),
                      Container(
                        color: Colors.white38,
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              orderList.length == null ? 0 : orderList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return orderList[i]['cart'] == null
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new OrderDetails(
                                                  orderId: orderList[i]["_id"]),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.white38,
                                          child: GFListTile(
                                            avatar: Container(
                                              width: 90.0,
                                              height: 90.0,
                                              child: Image.network(
                                                orderList[i]['cart']['cart'][0]
                                                    ['imageUrl'],
                                              ),
                                            ),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                bottom: 2.0),
                                                        child: Text(
                                                          orderList[i]['cart']
                                                                  ['cart'][0]
                                                              ['title'],
                                                          style: titleBold(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                bottom: 2.0),
                                                        child: Text(
                                                          orderList[i]['cart']['cart'][0][
                                                                          'description']
                                                                      .length >
                                                                  25
                                                              ? orderList[i]['cart']
                                                                          ['cart'][0][
                                                                      'description']
                                                                  .substring(
                                                                      0, 25)
                                                              : orderList[i]['cart']['cart'][0]
                                                                          ['description']
                                                                      .toString() ??
                                                                  "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w300,
                                                              fontSize: 14.0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 3.0,
                                                      bottom: 5.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          currency,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 11.0,
                                                          ),
                                                        ),
                                                        Text(orderList[i]
                                                                    ['grandTotal']
                                                                .toString() ??
                                                            "")
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        size: 15,
                                                        color: Colors.grey,
                                                      ),
                                                      Text(
                                                        'Ordered At : ' +
                                                                orderList[i][
                                                                        'createdAt']
                                                                    .substring(
                                                                        0, 10) +
                                                                " " +
                                                                orderList[i][
                                                                        'createdAt']
                                                                    .substring(
                                                                        11, 16) ??
                                                            "",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 11.0),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Order : ' ,
                                                        style: textBarlowRegularBlackwithOpa(),
                                                      ),
                                                      Text("${orderList[i]['orderStatus'] ?? ""}", style: textBarlowRegularGreen(),)
                                                    ],
                                                  ),
//                                                Row(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    Text(
//                                                      'Payment Type : ' +
//                                                          "${orderList[i]['paymentType'] ?? ""}",
//                                                      style: TextStyle(
//                                                          color: Colors.green),
//                                                    ),
//                                                  ],
//                                                ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        orderList[i]['orderStatus'] == "DELIVERED"
                                            ? Container(
                                                color: Colors.white38,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        height:45,
                                                        margin:EdgeInsets.only(left:20, right:15),
                                                        child: GFButton(
                                                          onPressed: () {
                                                            for (int j = 0;
                                                            j <
                                                                orderList[i][
                                                                'cart']
                                                                [
                                                                'cart']
                                                                    .length;
                                                            j++) {
                                                              addToCart(
                                                                  orderList[i]
                                                                  ['cart']
                                                                  ['cart'][j],
                                                                  orderList[i][
                                                                  'cart']
                                                                  ['cart']
                                                                      .length,
                                                                  j);
                                                            }
                                                          },
                                                          text: 'Reorder',
                                                          color: primary,
                                                        ),
                                                      )
                                                    ),
                                                    Expanded(child: Container(
                                                      height:45,
                                                      margin:EdgeInsets.only(right:20),
                                                      child: GFButton(onPressed: (){
                                                        setState(() {
                                                          showblur=true;
                                                          showRating= !showRating;
                                                        });
                                                      },
                                                      text: 'Rate',
                                                      type: GFButtonType.outline,
                                                        color: primary,
                                                      ),
                                                    )),
//                                                  showRating? Text('hi'):Container(),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    // orderList[i]['rating'] == null
                                                    //     ? Expanded(
                                                    //         child: Padding(
                                                    //           padding:
                                                    //               const EdgeInsets.only(
                                                    //                   left: 20.0,
                                                    //                   right: 20.0),
                                                    //           child: GFButton(
                                                    //             onPressed: () {
                                                    //               ratingAlert(orderList[i]
                                                    //                   ['_id']);
                                                    //             },
                                                    //             text: 'Order Rate',
                                                    //             color: primary,
                                                    //             type:
                                                    //                 GFButtonType.outline,
                                                    //             size: GFSize.SMALL,
                                                    //           ),
                                                    //         ),
                                                    //       )
                                                    //     : Expanded(
                                                    //         child: Padding(
                                                    //           padding:
                                                    //               const EdgeInsets.only(
                                                    //                   left: 20.0,
                                                    //                   right: 20.0),
                                                    //           child: GFButton(
                                                    //             onPressed: null,
                                                    //             text: orderList[i]
                                                    //                         ['rating']
                                                    //                     .toString() +
                                                    //                 " Order Rate",
                                                    //             color: Colors.black,
                                                    //             type:
                                                    //                 GFButtonType.outline,
                                                    //             size: GFSize.SMALL,
                                                    //           ),
                                                    // ),
                                                    // )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        Divider()
                                      ],
                                    ),
                                  );

                          },
                        ),
                      ),


                    ],
                  ),
      ),
    );


  }

  product(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 24),
//      color: bg,
      child: Row(
        children: <Widget>[
          Image.asset('lib/assets/images/cherry.png'),
          SizedBox(width: 17),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Lays lassic', style: textBarlowRegularrdark(),),
              SizedBox(height: 5),
              Text('Party pack (200 g)', style: textSMBarlowRegularrBlack(),),
              SizedBox(height: 10),
              Text('\$ 80', style: titleLargeSegoeBlack(),),
              SizedBox(height: 10),
              Text('Ordered : 02/02/2020,4.30 pm', style: textSMBarlowRegularrBlack(),)
            ],
          )
        ],
      ),
    );
  }
  orderTrack(){
    return Container(
//      color: bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GFListTile(
            avatar: Column(
              children: <Widget>[
                GFAvatar(
                  backgroundColor: green,
                  radius: 6,
                ),
                SizedBox(height: 10,),
                CustomPaint(painter: LineDashedPainter()),
              ],
            ),
            title: Text('Order Confirmed', style: titleSegoeGreen(),),
            subTitle: Text('4.30 pm', style: textSMBarlowRegularrGreyb(),),
          ),
          GFListTile(
            avatar: Column(
              children: <Widget>[
                GFAvatar(
                  backgroundColor: greyb.withOpacity(0.5),
                  radius: 6,
                ),
                SizedBox(height: 10,),
                CustomPaint(painter: LineDashedPainter()),
              ],
            ),
            title: Text('Out for delivery', style: titleSegoeGrey(),),
            subTitle: Text('', style: textSMBarlowRegularrGreyb(),),
          ),
          GFListTile(
            avatar: Column(
              children: <Widget>[
                GFAvatar(
                  backgroundColor: greyb.withOpacity(0.5),
                  radius: 6,
                ),
                SizedBox(height: 10,),
//                CustomPaint(painter: LineDashedPainter()),
              ],
            ),
            title: Text('Order delivered', style: titleSegoeGrey(),),
            subTitle: Text('', style: textSMBarlowRegularrGreyb(),),
          ),
        ],
      ),
    );
  }
}


class LineDashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..strokeWidth = 1;
    var max = 55;
    var dashWidth = 3;
    var dashSpace = 4;
    double startY = 0;
    while (max >= 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      final space = (dashSpace + dashWidth);
      startY += space;
      max -= space;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}