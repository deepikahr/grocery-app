import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymade_grocery_app/screens/orders/ordersDetails.dart';
import 'package:readymade_grocery_app/service/common.dart';
import 'package:readymade_grocery_app/service/constants.dart';
import 'package:readymade_grocery_app/service/localizations.dart';
import 'package:readymade_grocery_app/service/orderSevice.dart';
import 'package:readymade_grocery_app/service/sentry-service.dart';
import 'package:readymade_grocery_app/style/style.dart';
import 'package:readymade_grocery_app/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymade_grocery_app/widgets/normalText.dart';
import '../../style/style.dart';

SentryError sentryError = new SentryError();

class Orders extends StatefulWidget {
  final String? userID, locale;
  final Map? localizedValues;
  final bool? isSubscription;
  Orders({
    Key? key,
    this.userID,
    this.locale,
    this.localizedValues,
    this.isSubscription = false,
  }) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool isUserLoaggedIn = false,
      isFirstPageLoading = true,
      isNextPageLoading = false;
  int ordersPerPage = 12, ordersPageNumber = 0, totalOrders = 1;
  List orderList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? currency;
  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getorderList();
      }
    });
    checkIfUserIsLoaggedIn();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void checkIfUserIsLoaggedIn() async {
    setState(() {
      isFirstPageLoading = true;
    });
    orderList = [];
    ordersPageNumber = orderList.length;
    totalOrders = 1;
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        isUserLoaggedIn = true;
      }
      getorderList();
    });
  }

  void getorderList() async {
    if (totalOrders != orderList.length) {
      if (ordersPageNumber > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await OrderService.getOrderByUserID(ordersPageNumber, ordersPerPage,
              widget.isSubscription! ? "SUBSCRIPTIONS" : "PURCHASES")
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          orderList.addAll(onValue['response_data']);
          totalOrders = onValue["total"];
          ordersPageNumber++;
        }
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      body: Column(
        children: <Widget>[
          Flexible(
              child: isFirstPageLoading
                  ? Center(child: SquareLoader())
                  : orderList.length > 0
                      ? Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: false,
                            controller: _refreshController,
                            onRefresh: () {
                              checkIfUserIsLoaggedIn();
                            },
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: orderList.length,
                              itemBuilder: (BuildContext context, int i) {
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                            locale: widget.locale,
                                            localizedValues:
                                                widget.localizedValues,
                                            orderId: orderList[i]["_id"],
                                            isSubscription:
                                                widget.isSubscription,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          color: cartCardBg(context),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 1)
                                          ]),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 5),
                                          product(orderList[i]),
                                          orderList[i]['orderStatus'] !=
                                                      "CANCELLED" &&
                                                  orderList[i]['orderStatus'] !=
                                                      "DELIVERED" &&
                                                  orderList[i]['orderStatus'] !=
                                                      "PENDING"
                                              ? orderTrack(orderList[i])
                                              : Container(),
                                          SizedBox(height: 5)
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),
                        )
                      : noDataImage()),
          isNextPageLoading
              ? Container(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: SquareLoader(),
                )
              : Container()
        ],
      ),
    );
  }

  product(orderDetails) {
    return Row(
      children: <Widget>[
        (orderDetails['product']['productImages'] != null &&
                orderDetails['product']['productImages'].length > 0)
            ? CachedNetworkImage(
                imageUrl: orderDetails['product']['productImages'][0]
                            ['filePath'] !=
                        null
                    ? Constants.imageUrlPath! +
                        "/tr:dpr-auto,tr:w-500" +
                        orderDetails['product']['productImages'][0]['filePath']
                    : orderDetails['product']['productImages'][0]['imageUrl'],
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
                placeholder: (context, url) =>
                    Container(height: 70, width: 99, child: noDataImage()),
                errorWidget: (context, url, error) =>
                    Container(height: 70, width: 99, child: noDataImage()),
              )
            : CachedNetworkImage(
                imageUrl: orderDetails['product']['filePath'] == null
                    ? orderDetails['product']['imageUrl']
                    : Constants.imageUrlPath! +
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
                placeholder: (context, url) =>
                    Container(height: 70, width: 99, child: noDataImage()),
                errorWidget: (context, url, error) =>
                    Container(height: 70, width: 99, child: noDataImage()),
              ),
        SizedBox(width: 17),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orderPageText(context,
                '${MyLocalizations.of(context)!.getLocalizations("ORDER_ID", true)}  #${orderDetails['orderID']}'),
            orderPageText(context,
                '${orderDetails['product']['title'][0].toUpperCase()}${orderDetails['product']['title'].substring(1)}'),
            orderDetails['totalProduct'] > 1
                ? SizedBox(height: 5)
                : Container(),
            orderDetails['totalProduct'] > 1
                ? textLightSmall(
                    MyLocalizations.of(context)!.getLocalizations("AND") +
                        ' ${(orderDetails['totalProduct'] - 1).toString()} ' +
                        MyLocalizations.of(context)!
                            .getLocalizations("MORE_ITEMS"),
                    context)
                : Container(),
            buildBoldText(context,
                '$currency${orderDetails['grandTotal'] > 0 ? orderDetails['grandTotal'].toStringAsFixed(2) : orderDetails['usedWalletAmount'].toStringAsFixed(2)}'),
            textLightSmall(
                MyLocalizations.of(context)!.getLocalizations("ORDERED", true) +
                    DateFormat('dd/MM/yyyy, hh:mm a', widget.locale ?? "en")
                        .format(
                            DateTime.parse(orderDetails['createdAt'].toString())
                                .toLocal()),
                context)
          ],
        ),
      ],
    );
  }

  orderTrack(orderDetails) {
    return Column(
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
