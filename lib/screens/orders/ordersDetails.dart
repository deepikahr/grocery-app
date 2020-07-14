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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false,
      isRatingSubmitting = false,
      isOrderCancleLoading = false;
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
              if (orderHistory['usedWalletAmount'] == null) {
                orderHistory['usedWalletAmount'] = 0.0;
              }
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
              MyLocalizations.of(context).getLocalizations("RATE_PRODUCT"),
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
                  text: MyLocalizations.of(context).getLocalizations("SUBMIT"),
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

  orderCancleMethod() async {
    if (mounted) {
      setState(() {
        isOrderCancleLoading = true;
      });
    }
    Map body = {"orderId": widget.orderId, "status": "Cancelled"};

    await LoginService.orderCancle(body).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              getOrderHistory();
              showSnackbar(onValue['response_data']);
              isOrderCancleLoading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isOrderCancleLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isOrderCancleLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFDFDFD),
      appBar: GFAppBar(
        title: Text(
          MyLocalizations.of(context).getLocalizations("ORDER_DETAILS"),
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
                                        MyLocalizations.of(context)
                                            .getLocalizations("ORDER_ID", true),
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
                                        MyLocalizations.of(context)
                                            .getLocalizations("DATE", true),
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
                                            .getLocalizations(
                                                "DELIVERY_DATE", true),
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
                                        MyLocalizations.of(context)
                                            .getLocalizations(
                                                "DELIVERY_TIME", true),
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
                                            .getLocalizations(
                                                "PAYMENT_TYPE", true),
                                        style: textBarlowMediumBlack()),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          orderHistory['paymentType'] == 'COD'
                                              ? MyLocalizations.of(context)
                                                  .getLocalizations(
                                                      "CASH_ON_DELIVERY")
                                              : orderHistory['paymentType'] ==
                                                      "CARD"
                                                  ? MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "PAY_BY_CARD")
                                                  : orderHistory[
                                                              'paymentType'] ==
                                                          "WALLET"
                                                      ? MyLocalizations.of(
                                                              context)
                                                          .getLocalizations(
                                                              "WALLET")
                                                      : orderHistory[
                                                          'paymentType'],
                                          style: textBarlowMediumBlack()),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                orderHistory['paymentType'] == "CARD" ||
                                        orderHistory['paymentType'] == "WALLET"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              MyLocalizations.of(context)
                                                  .getLocalizations(
                                                      "PAYMENT_STATUS", true),
                                              style: textBarlowMediumBlack()),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                                orderHistory['transactionDetails']['transactionStatus'] == "succeeded" ||
                                                        orderHistory['transactionDetails']['transactionStatus'] ==
                                                            "Succeeded" ||
                                                        orderHistory['transactionDetails']['transactionStatus'] ==
                                                            "Succeed" ||
                                                        orderHistory['transactionDetails']['transactionStatus'] ==
                                                            "Succeed"
                                                    ? MyLocalizations.of(context)
                                                        .getLocalizations(
                                                            "SUCCESS")
                                                    : orderHistory['transactionDetails']['transactionStatus'] == "Pending" ||
                                                            orderHistory['transactionDetails']['transactionStatus'] ==
                                                                "pending"
                                                        ? MyLocalizations.of(context)
                                                            .getLocalizations(
                                                                "PENDING")
                                                        : orderHistory['transactionDetails']['transactionStatus'] == "Failed" ||
                                                                orderHistory['transactionDetails']
                                                                        ['transactionStatus'] ==
                                                                    "failed" ||
                                                                orderHistory['transactionDetails']['transactionStatus'] == "Fail" ||
                                                                orderHistory['transactionDetails']['transactionStatus'] == "fail"
                                                            ? MyLocalizations.of(context).getLocalizations("FAILED")
                                                            : orderHistory['transactionDetails']['transactionStatus'],
                                                style: textBarlowMediumBlack()),
                                          )
                                        ],
                                      )
                                    : Container(),
                                orderHistory['paymentType'] == "CARD" ||
                                        orderHistory['paymentType'] == "WALLET"
                                    ? SizedBox(height: 10)
                                    : Container(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        MyLocalizations.of(context)
                                            .getLocalizations(
                                                "ORDER_STAUS", true),
                                        style: textBarlowMediumBlack()),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          orderHistory['orderStatus'] == "DELIVERED"
                                              ? MyLocalizations.of(context)
                                                  .getLocalizations("DELIVERED")
                                              : orderHistory['orderStatus'] == "Cancelled"
                                                  ? MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "CANCELLED")
                                                  : orderHistory['orderStatus'] ==
                                                          "Out for delivery"
                                                      ? MyLocalizations.of(context)
                                                          .getLocalizations(
                                                              "OUT_FOR_DELIVERY")
                                                      : orderHistory['orderStatus'] ==
                                                              "Confirmed"
                                                          ? MyLocalizations.of(context)
                                                              .getLocalizations(
                                                                  "CONFIRMED")
                                                          : orderHistory['orderStatus'] ==
                                                                  "Pending"
                                                              ? MyLocalizations.of(context)
                                                                  .getLocalizations("PENDING")
                                                              : orderHistory['orderStatus'],
                                          style: textBarlowMediumGreen()),
                                    ),
                                  ],
                                ),
                                orderHistory['assignedTo'] != null &&
                                        orderHistory['assignedTo'] is Map
                                    ? SizedBox(height: 10)
                                    : Container(),
                                orderHistory['assignedTo'] != null &&
                                        orderHistory['assignedTo'] is Map
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              MyLocalizations.of(context)
                                                  .getLocalizations(
                                                      "ORDER_ASSIGNED", true),
                                              style: textBarlowMediumBlack()),
                                        ],
                                      )
                                    : Container(),
                                orderHistory['assignedTo'] != null &&
                                        orderHistory['assignedTo'] is Map &&
                                        orderHistory['assignedTo']
                                                ['firstName'] !=
                                            null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              MyLocalizations.of(context)
                                                  .getLocalizations(
                                                      "FULL_NAME", true),
                                              style: textBarlowMediumBlack()),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                                "${orderHistory['assignedTo']['firstName']} ${orderHistory['assignedTo']['lastName'] ?? ""}",
                                                style: textBarlowMediumBlack()),
                                          )
                                        ],
                                      )
                                    : Container(),
                                orderHistory['assignedTo'] != null &&
                                        orderHistory['assignedTo'] is Map
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              MyLocalizations.of(context)
                                                  .getLocalizations(
                                                      "CONTACT_NUMBER", true),
                                              style: textBarlowMediumBlack()),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                                "${orderHistory['assignedTo']['mobileNumber'].toString() ?? ""}",
                                                style: textBarlowMediumBlack()),
                                          )
                                        ],
                                      )
                                    : Container(),
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
                                              : Constants.imageUrlPath +
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
                                        MyLocalizations.of(context)
                                                .getLocalizations(
                                                    "DEAL_AMOUNT", true) +
                                            ' $currency${order['dealTotalAmount'].toStringAsFixed(2)}',
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
                                                      .getLocalizations(
                                                          "CONTACT_NUMBER"),
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
                          Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("SUB_TOTAL", true),
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
                                Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations("TAX", true),
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
                              MyLocalizations.of(context)
                                  .getLocalizations("DELIVERY_CHARGES", true),
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
                                      MyLocalizations.of(context)
                                          .getLocalizations("DELIVERY_CHARGES"),
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
                    orderHistory['usedWalletAmount'] == 0 ||
                            orderHistory['usedWalletAmount'] == 0.0
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations(
                                            "USED_WALLET_AMOUNT", true),
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
                                          orderHistory['usedWalletAmount']
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
                                    MyLocalizations.of(context)
                                            .getLocalizations(
                                                "COUPON_APPLIED") +
                                        " (" +
                                        "${MyLocalizations.of(context).getLocalizations("DISCOUNT")}"
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
                      Text(
                          MyLocalizations.of(context)
                              .getLocalizations("TOTAL", true),
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
                orderHistory['orderStatus'] == "DELIVERED" ||
                        orderHistory['orderStatus'] == "Cancelled"
                    ? Container()
                    : Container(
                        height: 45,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.29),
                              blurRadius: 5)
                        ]),
                        child: GFButton(
                          size: GFSize.LARGE,
                          color: primary,
                          blockButton: true,
                          onPressed: orderCancleMethod,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                MyLocalizations.of(context)
                                    .getLocalizations("CANCEL_ORDER"),
                                style: textBarlowRegularrBlack(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              isOrderCancleLoading
                                  ? GFLoader(
                                      type: GFLoaderType.ios,
                                    )
                                  : Text("")
                            ],
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}
