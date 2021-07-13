import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:readymadeGroceryApp/model/pausedSubscriptionBottomSheet.dart';
import 'package:readymadeGroceryApp/screens/subsription/add_edit_subscriptionPage.dart';
import 'package:readymadeGroceryApp/screens/subsription/subscriptionDetails.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../style/style.dart';
import '../../widgets/loader.dart';

SentryError sentryError = new SentryError();

class SubScriptionList extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;

  SubScriptionList({
    Key? key,
    this.locale,
    this.localizedValues,
  });
  @override
  _AllSubscribedState createState() => _AllSubscribedState();
}

class _AllSubscribedState extends State<SubScriptionList> {
  bool isUserLoaggedIn = false,
      isFirstPageLoading = true,
      isNextPageLoading = false,
      isSubscriptionPauseLoading = false,
      isSubscriptionCancelLoading = false;
  int? subscriptionPerPage = 12,
      subscriptionsPageNumber = 0,
      totalSubscription = 1,
      subscIndex;
  List subscriptionList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? currency;
  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    _scrollController.dispose();
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
      if (subscriptionsPageNumber! > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getSubscriptionListByUser(
              subscriptionsPageNumber, subscriptionPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          subscriptionList.addAll(onValue['response_data']);
          totalSubscription = onValue["total"];
          subscriptionsPageNumber = subscriptionsPageNumber! + 1;
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

  void subscriptionPause(subscriptionId, pauseBody, index) async {
    setState(() {
      isSubscriptionPauseLoading = true;
    });
    await ProductService.getSubscriptionPause(subscriptionId, pauseBody)
        .then((onValue) {
      if (mounted) {
        setState(() {
          isSubscriptionPauseLoading = false;
          showSnackbar(onValue['response_data']);
          subscriptionList[index]['status'] = "PAUSE";
          subscriptionList[index]['pauseStartDate'] =
              pauseBody['pauseStartDate'];
          subscriptionList[index]['pauseEndDate'] = pauseBody['pauseEndDate'];
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isSubscriptionPauseLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void getSubscriptionResume(subscriptionId, isResume, index) async {
    setState(() {
      isSubscriptionPauseLoading = true;
    });
    await ProductService.getSubscriptionResumeAndCancel(
            subscriptionId, isResume)
        .then((onValue) {
      if (mounted) {
        setState(() {
          isSubscriptionPauseLoading = false;
          showSnackbar(onValue['response_data']);
          subscriptionList[index]['status'] = "ACTIVE";
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isSubscriptionPauseLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void subscriptionCancelled(subId, index) async {
    setState(() {
      isSubscriptionCancelLoading = true;
    });
    await ProductService.getSubscriptionResumeAndCancel(subId, false)
        .then((onValue) {
      if (mounted) {
        setState(() {
          isSubscriptionCancelLoading = false;
          showSnackbar(onValue['response_data']);
          subscriptionList[index]['status'] = "CANCELLED";
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isSubscriptionCancelLoading = false;
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

  showCancelSubscription(index) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
            MyLocalizations.of(context)!.getLocalizations("ARE_YOU_SURE")),
        content: new Text(MyLocalizations.of(context)!
            .getLocalizations("YOU_WANT_TO_CANCEL_SUBSCRIPTION")),
        actions: <Widget>[
          GFButton(
             color: Colors.transparent,
            onPressed: () => Navigator.pop(context, false),
            child:
                new Text(MyLocalizations.of(context)!.getLocalizations("NO")),
          ),
        GFButton(
         color: Colors.transparent,
            onPressed: () {
              setState(() {
                subscIndex = index;
                subscriptionCancelled(subscriptionList[index]['_id'], index);
                Navigator.pop(context, false);
              });
            },
            child:
                new Text(MyLocalizations.of(context)!.getLocalizations("YES")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg(context),
      appBar: appBarPrimarynoradius(context, "SUBSCRIPTION_LIST")
          as PreferredSizeWidget?,
      body: Column(
        children: [
          Flexible(
              child: isFirstPageLoading
                  ? SquareLoader()
                  : subscriptionList.length > 0
                      ? SmartRefresher(
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
                            itemCount: subscriptionList.isEmpty
                                ? 0
                                : subscriptionList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubscriptionDetails(
                                            locale: widget.locale,
                                            localizedValues:
                                                widget.localizedValues,
                                            subscriptionId:
                                                subscriptionList[index]['_id'],
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
                                                      ? Constants.imageUrlPath! +
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
                                                      ? Constants
                                                              .imageUrlPath! +
                                                          "/tr:dpr-auto,tr:w-500" +
                                                          subscriptionList[index]
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
                                                                  context)!
                                                              .getLocalizations(
                                                                  "SUBSCRIPTION",
                                                                  true) +
                                                          MyLocalizations.of(
                                                                  context)!
                                                              .getLocalizations(
                                                                  subscriptionList[
                                                                          index]
                                                                      [
                                                                      'schedule'])),
                                                  SizedBox(height: 5),
                                                  textLightSmall(
                                                      MyLocalizations.of(
                                                                  context)!
                                                              .getLocalizations(
                                                                  "QUANTITY",
                                                                  true) +
                                                          subscriptionList[
                                                                          index]
                                                                      [
                                                                      'products']
                                                                  [
                                                                  0]['quantity']
                                                              .toString(),
                                                      context),
                                                  SizedBox(height: 5),
                                                  priceMrpText(
                                                      "$currency${subscriptionList[index]['products'][0]['subscriptionTotal']}",
                                                      "",
                                                      context),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: Divider(thickness: 1),
                                      ),
                                      subscriptionList[index]['status'] ==
                                              "CANCELLED"
                                          ? textLightSmall(
                                              'YOUR_SUBSCRIPTION_IS_CANCELLED',
                                              context)
                                          : Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Map productData = {
                                                          "productImages":
                                                              subscriptionList[
                                                                          index]
                                                                      [
                                                                      'products'][0]
                                                                  [
                                                                  'productImages'],
                                                          "imageUrl":
                                                              subscriptionList[
                                                                          index]
                                                                      [
                                                                      'products']
                                                                  [
                                                                  0]['imageUrl'],
                                                          "filePath":
                                                              subscriptionList[
                                                                          index]
                                                                      [
                                                                      'products']
                                                                  [
                                                                  0]['filePath']
                                                        };
                                                        var result =
                                                            Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => AddEditSubscriptionPage(
                                                                  currency:
                                                                      currency,
                                                                  localizedValues:
                                                                      widget
                                                                          .localizedValues,
                                                                  locale: widget
                                                                      .locale,
                                                                  subProductData:
                                                                      subscriptionList[
                                                                          index],
                                                                  productData:
                                                                      productData,
                                                                  isEdit:
                                                                      true)),
                                                        );
                                                        result.then((value) {
                                                          if (value != null) {
                                                            setState(() {
                                                              subscriptionList[
                                                                      index] =
                                                                  value;
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: subscribePrimary(
                                                          context,
                                                          "MODIFY",
                                                          false),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showCancelSubscription(
                                                            index);
                                                      },
                                                      child: subscribeButtonWithOutExpanded(
                                                          context,
                                                          "CANCEL",
                                                          subscIndex == index &&
                                                                  isSubscriptionCancelLoading
                                                              ? true
                                                              : false),
                                                    ),
                                                    subscriptionList[index]
                                                                ['status'] ==
                                                            "PAUSE"
                                                        ? InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                subscIndex =
                                                                    index;
                                                                getSubscriptionResume(
                                                                    subscriptionList[
                                                                            index]
                                                                        ['_id'],
                                                                    true,
                                                                    index);
                                                              });
                                                            },
                                                            child: subscribePrimary(
                                                                context,
                                                                "RESUME",
                                                                subscIndex ==
                                                                            index &&
                                                                        isSubscriptionPauseLoading
                                                                    ? true
                                                                    : false),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              var bottomSheet =
                                                                  showModalBottomSheet(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              bc) {
                                                                        return PausedSubscriptionBottomSheet(
                                                                          locale:
                                                                              widget.locale,
                                                                          localizedValues:
                                                                              widget.localizedValues,
                                                                          subscriptionStartDate:
                                                                              DateTime.parse(subscriptionList[index]['subscriptionStartDate']),
                                                                        );
                                                                      });
                                                              bottomSheet
                                                                  .then((data) {
                                                                if (data !=
                                                                    null) {
                                                                  setState(() {
                                                                    subscIndex =
                                                                        index;
                                                                    subscriptionPause(
                                                                        subscriptionList[index]
                                                                            [
                                                                            '_id'],
                                                                        data,
                                                                        index);
                                                                  });
                                                                }
                                                              });
                                                            },
                                                            child: subscribeButtonWithOutExpanded(
                                                                context,
                                                                "PAUSE",
                                                                subscIndex ==
                                                                            index &&
                                                                        isSubscriptionPauseLoading
                                                                    ? true
                                                                    : false),
                                                          ),
                                                  ],
                                                ),
                                                subscriptionList[index]
                                                            ['status'] ==
                                                        "PAUSE"
                                                    ? SizedBox(height: 10)
                                                    : Container(),
                                                subscriptionList[index]
                                                            ['status'] ==
                                                        "PAUSE"
                                                    ? textLightSmall(
                                                        "${MyLocalizations.of(context)!.getLocalizations("YOUR_SUBSCRIPTION_IS_PAUSED_FORM")} ${DateFormat('dd/MM/yyyy', widget.locale ?? "en").format(DateTime.parse(subscriptionList[index]['pauseStartDate'].toString()))} ${MyLocalizations.of(context)!.getLocalizations("TO")}  ${DateFormat('dd/MM/yyyy', widget.locale ?? "en").format(DateTime.parse(subscriptionList[index]['pauseEndDate'].toString()))}",
                                                        context)
                                                    : Container()
                                              ],
                                            ),
                                      SizedBox(height: 10)
                                    ],
                                  ),
                                ),
                              );
                            },
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
}
