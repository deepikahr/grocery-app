import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/orders/ordersDetails.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../style/style.dart';

SentryError sentryError = new SentryError();

class Orders extends StatefulWidget {
  final String userID, locale;
  final Map localizedValues;

  Orders({Key key, this.userID, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool isOrderListLoading = false,
      isOrderListLoadingSubProductsList = false,
      showRating = false,
      showblur = false,
      lastApiCall = true;
  int orderLimit = 10, orderIndex = 0, totalOrders = 1;

  List orderList = [];
  double rating;
  var orderedTime;
  String currency;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    if (mounted) {
      setState(() {
        isOrderListLoading = true;
      });
    }
    getOrderByUserID(orderIndex);
    super.initState();
  }

  getOrderByUserID(orderIndex) async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await OrderService.getOrderByUserID(orderIndex, orderLimit).then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          orderList.addAll(onValue['response_data']);
          totalOrders = onValue["total"];
          int index = orderList.length;
          if (lastApiCall == true) {
            orderIndex++;
            if (index < totalOrders) {
              getOrderByUserID(orderIndex);
            } else {
              if (index == totalOrders) {
                if (mounted) {
                  lastApiCall = false;
                  getOrderByUserID(orderIndex);
                }
              }
            }
          }
          isOrderListLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          orderList = [];
          isOrderListLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar: appBarprimary(context, "MY_ORDERS"),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          if (mounted) {
            setState(() {
              isOrderListLoading = true;
              orderList = [];
              orderIndex = orderList.length;
              getOrderByUserID(orderIndex);
            });
          }
        },
        child: isOrderListLoading
            ? SquareLoader()
            : orderList.length > 0
                ? ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              orderList.length == null ? 0 : orderList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetails(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues,
                                      orderId: orderList[i]["_id"],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  product(orderList[i]),
                                  orderList[i]['orderStatus'] != "CANCELLED" &&
                                          orderList[i]['orderStatus'] !=
                                              "DELIVERED" &&
                                          orderList[i]['orderStatus'] !=
                                              "PENDING"
                                      ? orderTrack(orderList[i])
                                      : Container(),
                                  SizedBox(height: 20)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  )
                : noDataImage(),
      ),
    );
  }

  product(orderDetails) {
    return Container(
      color: cartCardBg(context),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Row(
        children: <Widget>[
          (orderDetails['product']['productImages'] != null &&
                  orderDetails['product']['productImages'].length > 0)
              ? CachedNetworkImage(
                  imageUrl: orderDetails['product']['productImages'][0]
                              ['filePath'] ==
                          null
                      ? orderDetails['product']['productImages'][0]['imageUrl']
                      : Constants.imageUrlPath +
                          "/tr:dpr-auto,tr:w-500" +
                          orderDetails['product']['productImages'][0]
                              ['filePath'],
                  imageBuilder: (context, imageProvider) => Container(
                    height: 70,
                    width: 99,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF0000000A), blurRadius: 0.40)
                      ],
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                      height: 70,
                      width: 99,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF0000000A), blurRadius: 0.40)
                        ],
                      ),
                      child: noDataImage()),
                  errorWidget: (context, url, error) => Container(
                      height: 70,
                      width: 99,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF0000000A), blurRadius: 0.40)
                        ],
                      ),
                      child: noDataImage()),
                )
              : CachedNetworkImage(
                  imageUrl: orderDetails['product']['filePath'] == null
                      ? orderDetails['product']['imageUrl']
                      : Constants.imageUrlPath +
                          "/tr:dpr-auto,tr:w-500" +
                          orderDetails['product']['filePath'],
                  imageBuilder: (context, imageProvider) => Container(
                    height: 70,
                    width: 99,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF0000000A), blurRadius: 0.40)
                      ],
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                      height: 70,
                      width: 99,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF0000000A), blurRadius: 0.40)
                        ],
                      ),
                      child: noDataImage()),
                  errorWidget: (context, url, error) => Container(
                      height: 70,
                      width: 99,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF0000000A), blurRadius: 0.40)
                        ],
                      ),
                      child: noDataImage()),
                ),
          SizedBox(width: 17),
          Container(
            width: MediaQuery.of(context).size.width - 146,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                orderPageText(context,
                    '${MyLocalizations.of(context).getLocalizations("ORDER_ID", true)}  #${orderDetails['orderID']}'),
                orderPageText(context,
                    '${orderDetails['product']['title'][0].toUpperCase()}${orderDetails['product']['title'].substring(1)}'),
                orderDetails['totalProduct'] > 1
                    ? SizedBox(height: 5)
                    : Container(),
                orderDetails['totalProduct'] > 1
                    ? textLightSmall(
                        MyLocalizations.of(context).getLocalizations("AND") +
                            ' ${(orderDetails['totalProduct'] - 1).toString()} ' +
                            MyLocalizations.of(context)
                                .getLocalizations("MORE_ITEMS"),
                        context)
                    : Container(),
                SizedBox(height: 10),
                orderDetails['grandTotal'] > 0
                    ? buildBoldText(context,
                        '$currency${orderDetails['grandTotal'].toStringAsFixed(2)}')
                    : buildBoldText(context,
                        '$currency${orderDetails['usedWalletAmount'].toStringAsFixed(2)}'),
                SizedBox(height: 10),
                textLightSmall(
                    MyLocalizations.of(context)
                            .getLocalizations("ORDERED", true) +
                        DateFormat('dd/MM/yyyy, hh:mm a').format(
                            DateTime.parse(orderDetails['createdAt'].toString())
                                .toLocal()),
                    context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  orderTrack(orderDetails) {
    return Container(
      color: Color(0xFFF7F7F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          trackBuild(
              context,
              "ORDER_CONFIRMED",
              (orderDetails['orderStatus'] == "CONFIRMED" ||
                      orderDetails['orderStatus'] == "OUT_FOR_DELIVERY")
                  ? green
                  : greyb(context).withOpacity(0.5),
              orderDetails['orderStatus'] == "CONFIRMED" ||
                      orderDetails['orderStatus'] == "OUT_FOR_DELIVERY"
                  ? titleSegoeGreen(context)
                  : titleSegoegrey(context),
              orderDetails['orderStatus'] == "CONFIRMED" ||
                      orderDetails['orderStatus'] == "OUT_FOR_DELIVERY"
                  ? true
                  : false,
              false),
          trackBuild(
              context,
              "OUT_FOR_DELIVERY",
              orderDetails['orderStatus'] == "OUT_FOR_DELIVERY"
                  ? green
                  : greyb(context).withOpacity(0.5),
              orderDetails['orderStatus'] == "OUT_FOR_DELIVERY"
                  ? titleSegoeGreen(context)
                  : titleSegoegrey(context),
              orderDetails['orderStatus'] == "DELIVERED" ? true : false,
              false),
          trackBuild(
              context,
              "ORDER_DELIVERED",
              orderDetails['orderStatus'] == "DELIVERED"
                  ? green
                  : greyb(context).withOpacity(0.5),
              orderDetails['orderStatus'] == "DELIVERED"
                  ? titleSegoeGreen(context)
                  : titleSegoegrey(context),
              orderDetails['orderStatus'] == "DELIVERED" ? true : false,
              true),
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
