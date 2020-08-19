import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
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
  var createdAt;
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
    await OrderService.getOrderHistory(widget.orderId).then((onValue) {
      if (mounted) {
        setState(() {
          orderHistory = onValue['response_data'];
          if (orderHistory['walletAmount'] == null) {
            orderHistory['walletAmount'] = 0.0;
          }
          isLoading = false;
        });
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

  orderCancelMethod() async {
    if (mounted) {
      setState(() {
        isOrderCancleLoading = true;
      });
    }

    await OrderService.orderCancel(widget.orderId).then((onValue) {
      if (mounted) {
        setState(() {
          getOrderHistory();
          showSnackbar(onValue['response_data']);
          isOrderCancleLoading = false;
        });
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

  ratingAlert(productID) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            MyLocalizations.of(context).getLocalizations("RATE_PRODUCT"),
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                decoration: TextDecoration.none),
          ),
          actions: <Widget>[
            Center(
                child: InkWell(
              onTap: () {
                orderRating(productID);
              },
              child: alertSubmitButton(context, "SUBMIT"),
            ))
          ],
          content: Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(
                new Radius.circular(32.0),
              ),
            ),
            child: RatingBar(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 30.0,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: primary,
                size: 10.0,
              ),
              onRatingUpdate: (rate) {
                setState(() {
                  rating = rate;
                });
              },
            ),
          ),
        );
      },
    );
  }

  orderRating(productID) async {
    var body = {"rate": rating, "productId": productID};
    await ProductService.productRating(body).then((onValue) {
      Navigator.pop(context);
      setState(() {
        showSnackbar(onValue['response_data']);
        getOrderHistory();
      });
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFDFDFD),
      appBar: appBarPrimary(context, "ORDER_DETAILS"),
      body: isLoading
          ? SquareLoader()
          : orderHistory == null
              ? Center(
                  child: Image.asset('lib/assets/images/no-orders.png'),
                )
              : ListView(
                  children: <Widget>[
                    Container(
                      color: Color(0xFFF7F7F7),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 15),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "ORDER_ID", true) +
                                                  "#" +
                                                  orderHistory['order']
                                                          ['orderID']
                                                      .toString(),
                                              style: textBarlowMediumBlack()),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "DATE", true) +
                                                  DateFormat(
                                                          'dd/MM/yyyy, hh:mm a')
                                                      .format(DateTime.parse(
                                                              orderHistory[
                                                                          'order']
                                                                      [
                                                                      'createdAt']
                                                                  .toString())
                                                          .toLocal()),
                                              overflow: TextOverflow.ellipsis,
                                              style: textBarlowMediumBlack()),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "DELIVERY_DATE",
                                                          true) +
                                                  orderHistory['order']
                                                      ['deliveryDate'],
                                              overflow: TextOverflow.ellipsis,
                                              style: textBarlowMediumBlack()),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "DELIVERY_TIME",
                                                          true) +
                                                  orderHistory['order']
                                                      ['deliveryTime'],
                                              style: textBarlowMediumBlack()),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Constants.predefined == "true"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                    MyLocalizations.of(context)
                                                            .getLocalizations(
                                                                "TIME_ZONE_MESSAGE") +
                                                        " *",
                                                    style:
                                                        textBarlowMediumBlackRed()),
                                              )
                                            ],
                                          )
                                        : Container(),
                                    Constants.predefined == "true"
                                        ? SizedBox(height: 10)
                                        : Container(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "PAYMENT_TYPE", true) +
                                                  (orderHistory['order']['paymentType'] == 'COD'
                                                      ? MyLocalizations.of(context)
                                                          .getLocalizations(
                                                              "CASH_ON_DELIVERY")
                                                      : orderHistory['order']['paymentType'] == "CARD"
                                                          ? MyLocalizations.of(context)
                                                              .getLocalizations(
                                                                  "PAY_BY_CARD")
                                                          : orderHistory['order']['paymentType'] ==
                                                                  "WALLET"
                                                              ? MyLocalizations.of(context)
                                                                  .getLocalizations(
                                                                      "WALLET")
                                                              : orderHistory['order']
                                                                  ['paymentType']),
                                              style: textBarlowMediumBlack()),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "ADDRESS", true) +
                                                  orderHistory['order']
                                                      ['address']['address'],
                                              style: textBarlowMediumBlack()),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            MyLocalizations.of(context)
                                                .getLocalizations(
                                                    "ORDER_STAUS", true),
                                            style: textBarlowMediumBlack()),
                                        SizedBox(height: 5),
                                        Expanded(
                                          child: Text(
                                              orderHistory['order']['orderStatus'] == "DELIVERED"
                                                  ? MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "DELIVERED")
                                                  : orderHistory['order']
                                                              ['orderStatus'] ==
                                                          "CANCELLED"
                                                      ? MyLocalizations.of(context)
                                                          .getLocalizations(
                                                              "CANCELLED")
                                                      : orderHistory['order']['orderStatus'] == "OUT_FOR_DELIVERY"
                                                          ? MyLocalizations.of(context)
                                                              .getLocalizations(
                                                                  "OUT_FOR_DELIVERY")
                                                          : orderHistory['order']['orderStatus'] == "CONFIRMED"
                                                              ? MyLocalizations.of(context)
                                                                  .getLocalizations(
                                                                      "CONFIRMED")
                                                              : orderHistory['order']['orderStatus'] == "PENDING"
                                                                  ? MyLocalizations.of(context).getLocalizations("PENDING")
                                                                  : orderHistory['order']['orderStatus'],
                                              style: textBarlowMediumGreen()),
                                        ),
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
                    Divider(),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orderHistory['cart']['products'].length == null
                          ? 0
                          : orderHistory['cart']['products'].length,
                      itemBuilder: (BuildContext context, int i) {
                        Map order = orderHistory['cart']['products'][i];
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
                                                      "/tr:dpr-auto,tr:w-500" +
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
                                      '${order['productName']}' ?? "",
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
                                      ],
                                    ),
                                    orderHistory['order']['orderStatus'] ==
                                            "DELIVERED"
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                InkWell(
                                                    onTap: () {
                                                      if (order["rating"] !=
                                                              null &&
                                                          order["rating"] > 0) {
                                                        setState(() {
                                                          rating = double.parse(
                                                              order["rating"]
                                                                  .toString());
                                                        });
                                                      } else {
                                                        setState(() {
                                                          rating = 1.0;
                                                        });
                                                      }

                                                      ratingAlert(
                                                          order['productId']);
                                                    },
                                                    child: mdPillsButton(
                                                        context,
                                                        order["isRated"] == true
                                                            ? green
                                                            : primary,
                                                        "RATE_PRODUCT",
                                                        order))
                                              ],
                                            ),
                                          )
                                        : Container(),
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
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
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
                                        orderHistory['cart']['subTotal']
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
                        orderHistory['cart']['tax'] == 0
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                              orderHistory['cart']['tax']
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
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  MyLocalizations.of(context).getLocalizations(
                                      "DELIVERY_CHARGES", true),
                                  style: textBarlowMediumBlack()),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 5.0,
                                  ),
                                  child: orderHistory['cart']
                                              ['deliveryCharges'] ==
                                          0
                                      ? Text(
                                          MyLocalizations.of(context)
                                              .getLocalizations("FREE"),
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
                                              orderHistory['cart']
                                                      ['deliveryCharges']
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
                        orderHistory['cart']['walletAmount'] == 0 ||
                                orderHistory['cart']['walletAmount'] == 0.0
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                              orderHistory['cart']
                                                      ['walletAmount']
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
                        orderHistory['cart']['couponCode'] == null
                            ? Container()
                            : Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 18.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            MyLocalizations.of(context)
                                                .getLocalizations(
                                                    "COUPON_APPLIED", true),
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
                                                  '${orderHistory['cart']['couponCode']}',
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
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 18.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            MyLocalizations.of(context)
                                                .getLocalizations(
                                                    "DISCOUNT", true),
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
                                                  '${orderHistory['cart']['couponAmount'].toStringAsFixed(2)}',
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
                                    orderHistory['cart']['grandTotal']
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
                    orderHistory['order']['orderStatus'] == "DELIVERED" ||
                            orderHistory['order']['orderStatus'] == "CANCELLED"
                        ? Container()
                        : InkWell(
                            onTap: orderCancelMethod,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: buttonPrimary(context, "CANCEL_ORDER",
                                  isOrderCancleLoading),
                            )),
                    SizedBox(height: 20),
                  ],
                ),
    );
  }
}
