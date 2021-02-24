import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/orders/ordersDetails.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../style/style.dart';
import '../../widgets/loader.dart';

SentryError sentryError = new SentryError();

class SubScriptionListOrder extends StatefulWidget {
  final Map localizedValues;
  final String locale;

  SubScriptionListOrder({
    Key key,
    this.locale,
    this.localizedValues,
  });
  @override
  _AllSubscribedState createState() => _AllSubscribedState();
}

class _AllSubscribedState extends State<SubScriptionListOrder> {
  bool isUserLoaggedIn = false,
      isFirstPageLoading = true,
      isNextPageLoading = false;
  int subscriptionPerPage = 12,
      subscriptionsPageNumber = 0,
      totalSubscription = 1;
  List subscriptionList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String currency;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getsubscriptionList();
      }
    });
    checkIfUserIsLoaggedIn();
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController.dispose();
    super.dispose();
  }

  void checkIfUserIsLoaggedIn() async {
    setState(() {
      isFirstPageLoading = true;
    });
    subscriptionList = [];
    subscriptionsPageNumber = subscriptionList.length;
    totalSubscription = 1;
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        isUserLoaggedIn = true;
      }
      getsubscriptionList();
    });
  }

  void getsubscriptionList() async {
    if (totalSubscription != subscriptionList.length) {
      if (subscriptionsPageNumber > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getSubscriptionListOrder(
              subscriptionsPageNumber, subscriptionPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          subscriptionList.addAll(onValue['response_data']);
          totalSubscription = onValue["total"];
          subscriptionsPageNumber++;
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
        children: [
          Flexible(
            child: isFirstPageLoading
                ? SquareLoader()
                : subscriptionList.length > 0
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
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: subscriptionList.length == null
                                ? 0
                                : subscriptionList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetails(
                                            locale: widget.locale,
                                            localizedValues:
                                                widget.localizedValues,
                                            orderId: "603491b2336ebb221ff3903c",
                                            isSubscription:true,
                                          )),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: cartCardBg(context),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1)
                                      ]),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          (subscriptionList[index]['products']
                                                              [0]
                                                          ['productImages'] !=
                                                      null &&
                                                  subscriptionList[index][
                                                                  'products'][0]
                                                              ['productImages']
                                                          .length >
                                                      0)
                                              ? CachedNetworkImage(
                                                  imageUrl: subscriptionList[index]
                                                                      ['products'][0]
                                                                  ['productImages']
                                                              [0]['filePath'] !=
                                                          null
                                                      ? Constants.imageUrlPath +
                                                          "/tr:dpr-auto,tr:w-500" +
                                                          subscriptionList[index]
                                                                      ['products'][0]
                                                                  ['productImages']
                                                              [0]['filePath']
                                                      : subscriptionList[index]
                                                                  ['products'][0]
                                                              ['productImages']
                                                          [0]['imageUrl'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    height: 70,
                                                    width: 99,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                0xFF0000000A),
                                                            blurRadius: 0.40)
                                                      ],
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                          height: 70,
                                                          width: 99,
                                                          child: noDataImage()),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Container(
                                                          height: 70,
                                                          width: 99,
                                                          child: noDataImage()),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: subscriptionList[
                                                                      index]
                                                                  ['products']
                                                              [0]['filePath'] !=
                                                          null
                                                      ? Constants.imageUrlPath +
                                                          "/tr:dpr-auto,tr:w-500" +
                                                          subscriptionList[
                                                                      index]
                                                                  ['products']
                                                              [0]['filePath']
                                                      : subscriptionList[index]
                                                              ['products'][0]
                                                          ['imageUrl'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    height: 70,
                                                    width: 99,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                0xFF0000000A),
                                                            blurRadius: 0.40)
                                                      ],
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                          height: 70,
                                                          width: 99,
                                                          child: noDataImage()),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Container(
                                                          height: 70,
                                                          width: 99,
                                                          child: noDataImage()),
                                                ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${subscriptionList[index]['products'][0]['productName'][0].toUpperCase()}${subscriptionList[index]['products'][0]['productName'].substring(1)}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: 'BarlowRegular',
                                                    color: blackText(context),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 5),
                                              textLightSmall(
                                                  '${subscriptionList[index]['products'][0]['unit'] ?? ''}',
                                                  context),
                                              SizedBox(height: 5),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  regularTextatStart(
                                                      context,
                                                      MyLocalizations.of(
                                                                  context)
                                                              .getLocalizations(
                                                                  "SUBSCRIPTION",
                                                                  true) +
                                                          MyLocalizations.of(
                                                                  context)
                                                              .getLocalizations(
                                                                  subscriptionList[
                                                                          index]
                                                                      [
                                                                      'schedule'])),
                                                  SizedBox(height: 5),
                                                  priceMrpText(
                                                      "$currency${subscriptionList[index]['products'][0]['subscriptionTotal']} (${subscriptionList[index]['products'][0]['quantity'].toString()}*$currency${subscriptionList[index]['products'][0]['subScriptionAmount']})",
                                                      "",
                                                      context),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5)
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : noDataImage(),
          ),
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
}
