import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

SentryError sentryError = new SentryError();

class OrderDetails extends StatefulWidget {
  final String orderId, locale;
  final Map localizedValues;
  OrderDetails({Key key, this.orderId, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isLoading = false, isRatingSubmitting = false;
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
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await LoginService.getOrderHistory(widget.orderId).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              orderHistory = onValue['response_data'];
              isLoading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            orderHistory = null;
            isLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          orderHistory = null;
          isLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  ratingAlert(orderId, userId, productID) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(
              MyLocalizations.of(context).rateProduct,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
            actions: <Widget>[
              Center(
                  child: Container(
                child: GFButton(
                  onPressed: () {
                    if (!isRatingSubmitting) {
                      if (rating == null) {
                        rating = 3.0;
                      }
                      orderRating(orderId, rating, productID);
                    }
                  },
                  text: MyLocalizations.of(context).submit,
                  color: primary,
                  textStyle: textBarlowRegularBlack(),
                ),
              ))
            ],
            content: Container(
              // height: 220,
              // width: MediaQuery.of(context).size.width * 0.8,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(
                  new Radius.circular(32.0),
                ),
              ),
              child: RatingBar(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 44.0,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: primary,
                  size: 15.0,
                ),
                onRatingUpdate: (rate) {
                  setState(() {
                    rating = rate;
                  });
                },
              ),
            ));
      },
    );
  }

  orderRating(orderId, rating, productID) async {
    var body = {"rate": rating, "order": orderId, "productId": productID};
    setState(() {
      isRatingSubmitting = true;
    });
    await ProductService.productRate(body).then((onValue) {
      try {
        if (onValue['response_code'] == 201) {
          Navigator.pop(context);
          getOrderHistory();
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
      setState(() {
        isRatingSubmitting = false;
      });
    }).catchError((error) {
      sentryError.reportError(error, null);
      setState(() {
        isRatingSubmitting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: GFAppBar(
        title: Text(
          MyLocalizations.of(context).orderDetails,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: isLoading
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                Container(
                  color: Color(0xFFF7F7F7),
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 5,
                            fit: FlexFit.tight,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        MyLocalizations.of(context).orderID +
                                            " :",
                                        style: textBarlowMediumBlack()),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          "#" +
                                              orderHistory['orderID']
                                                  .toString(),
                                          style: textBarlowMediumBlack()),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        MyLocalizations.of(context).date + " :",
                                        style: textBarlowMediumBlack()),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          DateFormat('dd/MM/yyyy, hh:mm a')
                                              .format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        orderHistory[
                                                            'appTimestamp']),
                                              )
                                              .replaceAll('-', '/'),
                                          overflow: TextOverflow.ellipsis,
                                          style: textBarlowMediumBlack()),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        MyLocalizations.of(context)
                                                .deliveryDate +
                                            " :",
                                        style: textBarlowMediumBlack()),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          orderHistory['deliveryDate']
                                              .replaceAll('-', '/'),
                                          overflow: TextOverflow.ellipsis,
                                          style: textBarlowMediumBlack()),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        MyLocalizations.of(context).time + " :",
                                        style: textBarlowMediumBlack()),
                                    SizedBox(width: 3),
                                    Expanded(
                                      child: Text(orderHistory['deliveryTime'],
                                          style: textBarlowMediumBlack()),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        MyLocalizations.of(context)
                                                .paymentType +
                                            " :",
                                        style: textBarlowMediumBlack()),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(orderHistory['paymentType'],
                                          style: textBarlowMediumBlack()),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                orderHistory['paymentType'] == "CARD"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              MyLocalizations.of(context)
                                                      .paymentstatus +
                                                  " :",
                                              style: textBarlowMediumBlack()),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                                orderHistory[
                                                            'transactionDetails']
                                                        ['transactionStatus'] ??
                                                    "",
                                                style: textBarlowMediumBlack()),
                                          )
                                        ],
                                      )
                                    : Container(),
                                orderHistory['paymentType'] == "CARD"
                                    ? SizedBox(height: 10)
                                    : Container(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        MyLocalizations.of(context)
                                                .orderStatus +
                                            ' :',
                                        style: textBarlowMediumBlack()),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(orderHistory['orderStatus'],
                                          style: textBarlowMediumGreen()),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderHistory['cart']['cart'].length == null
                      ? 0
                      : orderHistory['cart']['cart'].length,
                  itemBuilder: (BuildContext context, int i) {
                    Map order = orderHistory['cart']['cart'][i];
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xFFF7F7F7),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 75,
                            width: 99,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF0000000A),
                                    blurRadius: 0.40)
                              ],
                              image: DecorationImage(
                                  image: order['filePath'] == null &&
                                          order['imageUrl'] == null
                                      ? AssetImage(
                                          'lib/assets/images/no-orders.png')
                                      : NetworkImage(
                                          order['filePath'] == null
                                              ? order['imageUrl']
                                              : Constants.IMAGE_URL_PATH +
                                                  "tr:dpr-auto,tr:w-500" +
                                                  order['filePath'],
                                        ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(width: 17),
                          Container(
                            width: MediaQuery.of(context).size.width - 146,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${order['title']}' ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: textBarlowRegularrdark(),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${order['unit']} (${order['quantity']}) *  $currency${order['price'].toStringAsFixed(2)}',
                                  style: textSMBarlowRegularrBlack(),
                                ),
                                order['dealTotalAmount'] == 0
                                    ? Container()
                                    : SizedBox(height: 5),
                                order['dealTotalAmount'] == 0
                                    ? Container()
                                    : Text(
                                        'Deal Amount : $currency${order['dealTotalAmount'].toStringAsFixed(2)}',
                                        style: textSMBarlowRegularrBlack(),
                                      ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '$currency ${order['productTotal'].toStringAsFixed(2)}',
                                      style: textBarlowMediumBlack(),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    orderHistory['orderStatus'] == "DELIVERED"
                                        ? order['rating'] == null
                                            ? GFButton(
                                                shape: GFButtonShape.pills,
                                                onPressed: () {
                                                  ratingAlert(
                                                      orderHistory['_id'],
                                                      orderHistory['user']
                                                          ['_id'],
                                                      order['productId']);
                                                },
                                                color: primary,
                                                child: Text(
                                                  MyLocalizations.of(context)
                                                      .rateNow,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            : RatingBar(
                                                initialRating:
                                                    order['rating'] == null
                                                        ? 0
                                                        : double.parse(order[
                                                                'rating']
                                                            .toStringAsFixed(
                                                                1)),
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 15.0,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 1.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.red,
                                                  size: 10.0,
                                                ),
                                                onRatingUpdate: null,
                                              )
                                        : Container()
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(MyLocalizations.of(context).subTotal + ' :',
                              style: textBarlowMediumBlack()),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    currency,
                                    style: textBarlowBoldBlack(),
                                  ),
                                  Text(
                                    orderHistory['subTotal'].toStringAsFixed(2),
                                    style: textBarlowBoldBlack(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    orderHistory['tax'] == 0
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(MyLocalizations.of(context).tax + ' :',
                                    style: textBarlowMediumBlack()),
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          currency,
                                          style: textBarlowBoldBlack(),
                                        ),
                                        Text(
                                          orderHistory['tax']
                                              .toStringAsFixed(2),
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
                          Text(
                              MyLocalizations.of(context).deliveryCharges +
                                  ' :',
                              style: textBarlowMediumBlack()),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                bottom: 5.0,
                              ),
                              child: orderHistory['deliveryCharges'] == 0
                                  ? Text(
                                      MyLocalizations.of(context).free,
                                      style: textBarlowBoldBlack(),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          currency,
                                          style: textBarlowBoldBlack(),
                                        ),
                                        Text(
                                          orderHistory['deliveryCharges']
                                              .toStringAsFixed(2),
                                          style: textBarlowBoldBlack(),
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    orderHistory['cart']['couponInfo'] == null
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    MyLocalizations.of(context).couponApplied +
                                        " (" +
                                        "${MyLocalizations.of(context).discount}"
                                            ") :",
                                    style: textBarlowMediumBlack()),
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                      bottom: 5.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          currency,
                                          style: textBarlowBoldBlack(),
                                        ),
                                        Text(
                                          '${orderHistory['cart']['couponInfo']['couponDiscountAmount'].toStringAsFixed(2)}',
                                          style: textBarlowBoldBlack(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(height: 6),
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
                      Text(MyLocalizations.of(context).grandTotal + " :",
                          style: textBarlowMediumBlack()),
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
                                style: textBarlowBoldBlack(),
                              ),
                              Text(
                                orderHistory['grandTotal'].toStringAsFixed(2),
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
    );
  }
}
