import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:readymadeGroceryApp/screens/orders/rateDelivery.dart';
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
  final String? orderId, locale;
  final Map? localizedValues;
  final bool isSubscription;
  OrderDetails({
    Key? key,
    this.orderId,
    this.locale,
    this.localizedValues,
    this.isSubscription = false,
  }) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false,
      isRatingSubmitting = false,
      isOrderCancleLoading = false;
  var orderHistory;
  late String currency;
  double? rating;
  Timer? timer;
  int? productInfoIndex = -1;
  @override
  void initState() {
    getOrderHistory();
    super.initState();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    timer =
        Timer.periodic(Duration(seconds: 15), (Timer t) => getOrderHistory());
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    super.dispose();
  }

  getOrderHistory() async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await OrderService.getOrderHistory(widget.orderId).then((onValue) {
      if (mounted) {
        setState(() {
          orderHistory = onValue['response_data'];
          productInfoIndex = orderHistory['order']['cart']
              .toList()
              .indexWhere((product) => product['isOrderModified'] == true);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }

  ratingAlert(productID) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            MyLocalizations.of(context)!.getLocalizations("RATE_PRODUCT"),
            style: TextStyle(
                color: dark(context),
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
            child: RatingBar.builder(
              initialRating: rating!,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 30.0,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: primary(context),
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
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "ORDER_DETAILS") as PreferredSizeWidget?,
      body: isLoading
          ? SquareLoader()
          : orderHistory == null
              ? noDataImage()
              : ListView(
                  children: <Widget>[
                    Container(
                      color: cartCardBg(context),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          productInfoIndex == -1
                              ? Container()
                              : buildOrderDetilsNormalText(
                                  context, "ORDER_MODIFIED"),
                          productInfoIndex == -1
                              ? Container()
                              : SizedBox(height: 10),
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
                                        DateFormat('dd/MM/yyyy, hh:mm a',
                                                widget.locale ?? "en")
                                            .format(DateTime.parse(
                                                    orderHistory['order']
                                                            ['createdAt']
                                                        .toString())
                                                .toLocal())),
                                    widget.isSubscription == true
                                        ? Container()
                                        : SizedBox(height: 10),
                                    widget.isSubscription == true
                                        ? Container()
                                        : buildOrderDetilsStatusText(
                                            context,
                                            "SHIPPING_METHOD",
                                            (orderHistory['order']
                                                        ['shippingMethod'] ==
                                                    null
                                                ? "DELIVERY"
                                                : orderHistory['order']
                                                    ['shippingMethod'])),
                                    widget.isSubscription == true
                                        ? Container()
                                        : SizedBox(height: 10),
                                    widget.isSubscription == true
                                        ? Container()
                                        : buildOrderDetilsText(
                                            context,
                                            (orderHistory['order']
                                                        ['shippingMethod'] ==
                                                    "PICK_UP"
                                                ? "PICK_UP_DATE"
                                                : "DELIVERY_DATE"),
                                            orderHistory['order']
                                                ['deliveryDate']),
                                    widget.isSubscription == true
                                        ? Container()
                                        : SizedBox(height: 10),
                                    widget.isSubscription == true
                                        ? Container()
                                        : buildOrderDetilsText(
                                            context,
                                            (orderHistory['order']
                                                        ['shippingMethod'] ==
                                                    "PICK_UP"
                                                ? "PICK_UP_TIME"
                                                : "DELIVERY_TIME"),
                                            orderHistory['order']
                                                ['deliveryTime']),
                                    SizedBox(height: 10),
                                    widget.isSubscription == true
                                        ? Container()
                                        : Constants.predefined == "true"
                                            ? timeZoneMessage(
                                                context, "TIME_ZONE_MESSAGE")
                                            : Container(),
                                    buildOrderDetilsText(
                                        context,
                                        "PAYMENT_TYPE",
                                        widget.isSubscription == true
                                            ? "WALLET"
                                            : orderHistory['order']
                                                ['paymentType']),
                                    SizedBox(height: 10),
                                    buildOrderDetilsText(
                                        context,
                                        (orderHistory['order']
                                                    ['shippingMethod'] ==
                                                "PICK_UP"
                                            ? "PICK_UP_ADDRESS"
                                            : "ADDRESS"),
                                        (orderHistory['order']
                                                    ['shippingMethod'] ==
                                                "PICK_UP"
                                            ? orderHistory['order']
                                                ['storeAddress']['address']
                                            : orderHistory['order']['address']
                                                ['address'])),
                                    widget.isSubscription == true
                                        ? Container()
                                        : SizedBox(height: 10),
                                    widget.isSubscription == true
                                        ? Container()
                                        : buildOrderDetilsStatusText(
                                            context,
                                            "ORDER_STAUS",
                                            orderHistory['order']
                                                ['orderStatus']),
                                    widget.isSubscription == true
                                        ? Container()
                                        : SizedBox(height: 10),
                                    widget.isSubscription == true
                                        ? Container()
                                        : buildOrderDetilsStatusText(
                                            context,
                                            "PAYMENT_STATUS",
                                            orderHistory['order']
                                                ['paymentStatus']),
                                    orderHistory['order']
                                                    ['deliveryInstruction'] ==
                                                null ||
                                            widget.isSubscription == true
                                        ? Container()
                                        : SizedBox(height: 10),
                                    orderHistory['order']
                                                    ['deliveryInstruction'] ==
                                                null ||
                                            widget.isSubscription == true
                                        ? Container()
                                        : buildOrderDetilsText(
                                            context,
                                            "INSTRUCTION",
                                            orderHistory['order']
                                                ['deliveryInstruction']),
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
                      itemCount: orderHistory['order']['cart'].length == null
                          ? 0
                          : orderHistory['order']['cart'].length,
                      itemBuilder: (BuildContext context, int i) {
                        Map order = orderHistory['order']['cart'][i];
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: cartCardBg(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Row(
                                children: <Widget>[
                                  (order["productImages"] != null &&
                                          order["productImages"].length > 0)
                                      ? CachedNetworkImage(
                                          imageUrl: order["productImages"][0]
                                                      ['filePath'] ==
                                                  null
                                              ? order["productImages"][0]
                                                  ['imageUrl']
                                              : Constants.imageUrlPath! +
                                                  "/tr:dpr-auto,tr:w-500" +
                                                  order["productImages"][0]
                                                      ['filePath'],
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                          placeholder: (context, url) =>
                                              Container(
                                                  height: 75,
                                                  width: 99,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(
                                                              0xFF0000000A),
                                                          blurRadius: 0.40)
                                                    ],
                                                  ),
                                                  child: noDataImage()),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  height: 75,
                                                  width: 99,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(
                                                              0xFF0000000A),
                                                          blurRadius: 0.40)
                                                    ],
                                                  ),
                                                  child: noDataImage()),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: order['filePath'] == null
                                              ? order['imageUrl']
                                              : Constants.imageUrlPath! +
                                                  "/tr:dpr-auto,tr:w-500" +
                                                  order['filePath'],
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                          placeholder: (context, url) =>
                                              Container(
                                                  height: 75,
                                                  width: 99,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(
                                                              0xFF0000000A),
                                                          blurRadius: 0.40)
                                                    ],
                                                  ),
                                                  child: noDataImage()),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  height: 75,
                                                  width: 99,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(
                                                              0xFF0000000A),
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
                                            order['productName'] ?? "",
                                            context),
                                        SizedBox(height: 5),
                                        order['isOrderModified'] == true
                                            ? Column(
                                                children: [
                                                  textMediumSmallGreen(
                                                      MyLocalizations.of(
                                                                  context)!
                                                              .getLocalizations(
                                                                  "ORIGINAL_PRICE",
                                                                  true) +
                                                          ' $currency${order['originalPrice'] == null ? order['price'].toStringAsFixed(2) : order['originalPrice'].toStringAsFixed(2)}',
                                                      context),
                                                  SizedBox(height: 5)
                                                ],
                                              )
                                            : Container(),
                                        textLightSmall(
                                            '${order['unit']} (${order['quantity']}) *  $currency${order['price'].toStringAsFixed(2)}',
                                            context),
                                        order['dealTotalAmount'] == 0
                                            ? Container()
                                            : SizedBox(height: 5),
                                        order['dealTotalAmount'] == 0
                                            ? Container()
                                            : textLightSmall(
                                                MyLocalizations.of(context)!
                                                        .getLocalizations(
                                                            "DEAL_AMOUNT",
                                                            true) +
                                                    ' $currency${order['dealTotalAmount'].toStringAsFixed(2)}',
                                                context),
                                        SizedBox(height: 10),
                                        textMediumSmall(
                                            "$currency ${order['productTotal'].toStringAsFixed(2)}",
                                            context),
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
                                                              rating =
                                                                  double.parse(
                                                                order["rating"]
                                                                    .toString(),
                                                              );
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
                                                                : primary(
                                                                    context),
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
                              MyLocalizations.of(context)!
                                  .getLocalizations("SUB_TOTAL"),
                              currency +
                                  orderHistory['order']['subTotal']
                                      .toStringAsFixed(2),
                              false),
                          widget.isSubscription == true
                              ? Container()
                              : SizedBox(height: 6),
                          widget.isSubscription == true
                              ? Container()
                              : orderHistory['order']['tax'] == 0
                                  ? Container()
                                  : buildPriceBold(
                                      context,
                                      null,
                                      MyLocalizations.of(context)!
                                          .getLocalizations("TAX"),
                                      currency +
                                          orderHistory['order']['tax']
                                              .toStringAsFixed(2),
                                      false),
                          SizedBox(height: 6),
                          buildPriceBold(
                              context,
                              null,
                              MyLocalizations.of(context)!
                                  .getLocalizations("DELIVERY_CHARGES"),
                              orderHistory['order']['deliveryCharges'] == 0
                                  ? MyLocalizations.of(context)!
                                      .getLocalizations("FREE")
                                  : orderHistory['order']['deliveryCharges']
                                      .toStringAsFixed(2),
                              false),
                          SizedBox(height: 6),
                          widget.isSubscription == true
                              ? Container()
                              : orderHistory['order']['usedWalletAmount'] ==
                                          0 ||
                                      orderHistory['order']
                                              ['usedWalletAmount'] ==
                                          0.0
                                  ? Container()
                                  : buildPriceBold(
                                      context,
                                      null,
                                      MyLocalizations.of(context)!
                                          .getLocalizations("PAID_FORM_WALLET"),
                                      "-" +
                                          currency +
                                          orderHistory['order']
                                                  ['usedWalletAmount']
                                              .toStringAsFixed(2),
                                      false),
                          widget.isSubscription == true
                              ? Container()
                              : SizedBox(height: 6),
                          widget.isSubscription == true
                              ? Container()
                              : orderHistory['order']['couponCode'] == null
                                  ? Container()
                                  : Column(
                                      children: <Widget>[
                                        buildPriceBold(
                                            context,
                                            null,
                                            MyLocalizations.of(context)!
                                                .getLocalizations(
                                                    "COUPON_APPLIED"),
                                            orderHistory['order']['couponCode'],
                                            false),
                                        SizedBox(height: 6),
                                        buildPriceBold(
                                            context,
                                            null,
                                            MyLocalizations.of(context)!
                                                .getLocalizations("DISCOUNT"),
                                            "-" +
                                                currency +
                                                orderHistory['order']
                                                        ['couponAmount']
                                                    .toStringAsFixed(2),
                                            false),
                                      ],
                                    ),
                          widget.isSubscription == true
                              ? Container()
                              : SizedBox(height: 6),
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
                          MyLocalizations.of(context)!
                              .getLocalizations("TOTAL"),
                          currency +
                              (widget.isSubscription
                                      ? orderHistory['order']
                                          ['usedWalletAmount']
                                      : orderHistory['order']['grandTotal'])
                                  .toStringAsFixed(2),
                          false),
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child:
                          orderHistory['order']['orderStatus'] == "DELIVERED" ||
                                  orderHistory['order']['orderStatus'] ==
                                      "CANCELLED" ||
                                  widget.isSubscription == true
                              ? Container()
                              : InkWell(
                                  onTap: orderCancelMethod,
                                  child: orderHistory['order']['orderStatus'] ==
                                          "PENDING"
                                      ? buttonprimary(context, "CANCEL_ORDER",
                                          isOrderCancleLoading)
                                      : Container(),
                                ),
                    ),
                    orderHistory['order']['isDeliveryBoyRated'] == false &&
                            orderHistory['order']['orderStatus'] == "DELIVERED"
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: InkWell(
                              onTap: () {
                                var result = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RateDelivery(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        orderHistory: orderHistory),
                                  ),
                                );
                                result.then((value) {
                                  if (value != null && value == true) {
                                    getOrderHistory();
                                  }
                                });
                              },
                              child: buttonprimary(context, "RATE_DELIVERY",
                                  isOrderCancleLoading),
                            ),
                          )
                        : Container(),
                    SizedBox(height: 20),
                  ],
                ),
    );
  }
}
