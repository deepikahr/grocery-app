import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:readymadeGroceryApp/widgets/normalText.dart';

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
              ? noDataImage()
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
                                    buildOrderDetilsText(
                                        context,
                                        "ORDER_ID",
                                        "#" +
                                            orderHistory['order']['orderID']
                                                .toString()),
                                    SizedBox(height: 10),
                                    buildOrderDetilsText(
                                        context,
                                        "DATE",
                                        DateFormat('dd/MM/yyyy, hh:mm a')
                                            .format(DateTime.parse(
                                                    orderHistory['order']
                                                            ['createdAt']
                                                        .toString())
                                                .toLocal())),
                                    SizedBox(height: 10),
                                    buildOrderDetilsText(
                                        context,
                                        "DELIVERY_DATE",
                                        orderHistory['order']['deliveryDate']),
                                    SizedBox(height: 10),
                                    buildOrderDetilsText(
                                        context,
                                        "DELIVERY_TIME",
                                        orderHistory['order']['deliveryTime']),
                                    SizedBox(height: 10),
                                    Constants.predefined == "true"
                                        ? timeZoneMessage(
                                            context, "TIME_ZONE_MESSAGE")
                                        : Container(),
                                    buildOrderDetilsText(
                                        context,
                                        "PAYMENT_TYPE",
                                        (orderHistory['order']['paymentType'] ==
                                                'COD'
                                            ? "CASH_ON_DELIVERY"
                                            : orderHistory['order']
                                                        ['paymentType'] ==
                                                    "STRIPE"
                                                ? "PAY_BY_CARD"
                                                : orderHistory['order']
                                                            ['paymentType'] ==
                                                        "WALLET"
                                                    ? "WALLET"
                                                    : orderHistory['order'][
                                                                'paymentType'] ==
                                                            "FAWATERK"
                                                        ? "FAWATERK"
                                                        : orderHistory['order']
                                                            ['paymentType'])),
                                    SizedBox(height: 10),
                                    buildOrderDetilsText(
                                        context,
                                        "ADDRESS",
                                        orderHistory['order']['address']
                                            ['address']),
                                    SizedBox(height: 10),
                                    buildOrderDetilsStatusText(
                                        context,
                                        "ORDER_STAUS",
                                        (orderHistory['order']['orderStatus'] ==
                                                "DELIVERED"
                                            ? "DELIVERED"
                                            : orderHistory['order']
                                                        ['orderStatus'] ==
                                                    "CANCELLED"
                                                ? "CANCELLED"
                                                : orderHistory['order']
                                                            ['orderStatus'] ==
                                                        "OUT_FOR_DELIVERY"
                                                    ? "OUT_FOR_DELIVERY"
                                                    : orderHistory['order'][
                                                                'orderStatus'] ==
                                                            "CONFIRMED"
                                                        ? "CONFIRMED"
                                                        : orderHistory['order'][
                                                                    'orderStatus'] ==
                                                                "PENDING"
                                                            ? "PENDING"
                                                            : orderHistory[
                                                                    'order'][
                                                                'orderStatus'])),
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
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Color(0xFFF7F7F7),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Row(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: order['filePath'] == null
                                        ? order['imageUrl']
                                        : Constants.imageUrlPath +
                                            "/tr:dpr-auto,tr:w-500" +
                                            order['filePath'],
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 75,
                                      width: 99,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xFF0000000A),
                                              blurRadius: 0.40)
                                        ],
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                        height: 75,
                                        width: 99,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0xFF0000000A),
                                                blurRadius: 0.40)
                                          ],
                                        ),
                                        child: SquareLoader(size: 20.0)),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            height: 75,
                                            width: 99,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(0xFF0000000A),
                                                    blurRadius: 0.40)
                                              ],
                                            ),
                                            child: noDataImage()),
                                  ),
                                  SizedBox(width: 17),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 146,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        textMediumSmall(
                                            order['productName'] ?? ""),
                                        SizedBox(height: 10),
                                        textLightSmall(
                                            '${order['unit']} (${order['quantity']}) *  $currency${order['price'].toStringAsFixed(2)}'),
                                        order['dealTotalAmount'] == 0
                                            ? Container()
                                            : SizedBox(height: 5),
                                        order['dealTotalAmount'] == 0
                                            ? Container()
                                            : textLightSmall(MyLocalizations.of(
                                                        context)
                                                    .getLocalizations(
                                                        "DEAL_AMOUNT", true) +
                                                ' $currency${order['dealTotalAmount'].toStringAsFixed(2)}'),
                                        SizedBox(height: 10),
                                        textMediumSmall(
                                            "$currency ${order['productTotal'].toStringAsFixed(2)}"),
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
                                                              order["rating"] >
                                                                  0) {
                                                            setState(() {
                                                              rating = double
                                                                  .parse(order[
                                                                          "rating"]
                                                                      .toString());
                                                            });
                                                          } else {
                                                            setState(() {
                                                              rating = 1.0;
                                                            });
                                                          }

                                                          ratingAlert(order[
                                                              'productId']);
                                                        },
                                                        child: mdPillsButton(
                                                            context,
                                                            order["isRated"] ==
                                                                    true
                                                                ? green
                                                                : primary,
                                                            "RATE_PRODUCT",
                                                            order))
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Divider(thickness: 1),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Column(
                        children: <Widget>[
                          buildPriceBold(
                              context,
                              null,
                              MyLocalizations.of(context)
                                  .getLocalizations("SUB_TOTAL"),
                              currency +
                                  orderHistory['cart']['subTotal']
                                      .toStringAsFixed(2),
                              false),
                          SizedBox(height: 6),
                          orderHistory['cart']['tax'] == 0
                              ? Container()
                              : buildPriceBold(
                                  context,
                                  null,
                                  MyLocalizations.of(context)
                                      .getLocalizations("TAX"),
                                  currency +
                                      orderHistory['cart']['tax']
                                          .toStringAsFixed(2),
                                  false),
                          SizedBox(height: 6),
                          buildPriceBold(
                              context,
                              null,
                              MyLocalizations.of(context)
                                  .getLocalizations("DELIVERY_CHARGES"),
                              orderHistory['cart']['deliveryCharges'] == 0
                                  ? MyLocalizations.of(context)
                                      .getLocalizations("FREE")
                                  : orderHistory['cart']['deliveryCharges']
                                      .toStringAsFixed(2),
                              false),
                          SizedBox(height: 6),
                          orderHistory['cart']['walletAmount'] == 0 ||
                                  orderHistory['cart']['walletAmount'] == 0.0
                              ? Container()
                              : buildPriceBold(
                                  context,
                                  null,
                                  MyLocalizations.of(context)
                                      .getLocalizations("USED_WALLET_AMOUNT"),
                                  currency +
                                      orderHistory['cart']['walletAmount']
                                          .toStringAsFixed(2),
                                  false),
                          SizedBox(height: 6),
                          orderHistory['cart']['couponCode'] == null
                              ? Container()
                              : Column(
                                  children: <Widget>[
                                    buildPriceBold(
                                        context,
                                        null,
                                        MyLocalizations.of(context)
                                            .getLocalizations("COUPON_APPLIED"),
                                        orderHistory['cart']['couponCode'],
                                        false),
                                    SizedBox(height: 6),
                                    buildPriceBold(
                                        context,
                                        null,
                                        currency +
                                            MyLocalizations.of(context)
                                                .getLocalizations("DISCOUNT"),
                                        orderHistory['cart']['couponAmount']
                                            .toStringAsFixed(2),
                                        false),
                                  ],
                                ),
                          SizedBox(height: 6),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: buildPriceBold(
                          context,
                          null,
                          MyLocalizations.of(context).getLocalizations("TOTAL"),
                          currency +
                              orderHistory['cart']['grandTotal']
                                  .toStringAsFixed(2),
                          false),
                    ),
                    SizedBox(height: 6),
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
