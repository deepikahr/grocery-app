import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';

SentryError sentryError = new SentryError();

class SubscriptionDetails extends StatefulWidget {
  SubscriptionDetails(
      {Key? key, this.locale, this.localizedValues, this.subscriptionId})
      : super(key: key);

  final Map? localizedValues;
  final String? locale, subscriptionId;

  @override
  _SubscriptionDetailsState createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  bool isGetSubscribedProductLoading = false;
  Map? subscribedDetails;
  List subscriptionStatusList = [];
  String? currency;
  @override
  void initState() {
    getProductsList();
    super.initState();
  }

  void getProductsList() async {
    setState(() {
      isGetSubscribedProductLoading = true;
    });
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await ProductService.getSubscriptionDetails(widget.subscriptionId)
        .then((onValue) {
      if (mounted) {
        setState(() {
          isGetSubscribedProductLoading = false;
          subscribedDetails = onValue['response_data'];
          subscriptionStatusList =
              subscribedDetails!['subscriptionStatus'] ?? [];
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetSubscribedProductLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar: appBarPrimarynoradius(context, "DETAILS") as PreferredSizeWidget?,
      body: isGetSubscribedProductLoading
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                      color: cartCardBg(context),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 1)
                      ]),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          (subscribedDetails!['subscription']['products'][0]
                                          ['productImages'] !=
                                      null &&
                                  subscribedDetails!['subscription']['products']
                                              [0]['productImages']
                                          .length >
                                      0)
                              ? CachedNetworkImage(
                                  imageUrl: subscribedDetails!['subscription']
                                                      ['products'][0]
                                                  ['productImages'][0]
                                              ['filePath'] !=
                                          null
                                      ? Constants.imageUrlPath! +
                                          "/tr:dpr-auto,tr:w-500" +
                                          subscribedDetails!['subscription']
                                                  ['products'][0]
                                              ['productImages'][0]['filePath']
                                      : subscribedDetails!['subscription']
                                              ['products'][0]['productImages']
                                          [0]['imageUrl'],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 70,
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
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                      height: 70,
                                      width: 99,
                                      child: noDataImage()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          height: 70,
                                          width: 99,
                                          child: noDataImage()),
                                )
                              : CachedNetworkImage(
                                  imageUrl: subscribedDetails!['subscription']
                                              ['products'][0]['filePath'] !=
                                          null
                                      ? Constants.imageUrlPath! +
                                          "/tr:dpr-auto,tr:w-500" +
                                          subscribedDetails!['subscription']
                                              ['products'][0]['filePath']
                                      : subscribedDetails!['subscription']
                                          ['products'][0]['imageUrl'],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 70,
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
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                      height: 70,
                                      width: 99,
                                      child: noDataImage()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          height: 70,
                                          width: 99,
                                          child: noDataImage()),
                                ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${subscribedDetails!['subscription']['products'][0]['productName'][0].toUpperCase()}${subscribedDetails!['subscription']['products'][0]['productName'].substring(1)}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'BarlowRegular',
                                    color: blackText(context),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 5),
                              textLightSmall(
                                  '${subscribedDetails!['subscription']['products'][0]['unit'] ?? ''}',
                                  context),
                              SizedBox(height: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularTextatStart(
                                      context,
                                      MyLocalizations.of(context)!
                                              .getLocalizations(
                                                  "SUBSCRIPTION", true) +
                                          MyLocalizations.of(context)!
                                              .getLocalizations(
                                                  subscribedDetails![
                                                          'subscription']
                                                      ['schedule'])),
                                  SizedBox(height: 5),
                                  textLightSmall(
                                      MyLocalizations.of(context)!
                                              .getLocalizations(
                                                  "QUANTITY", true) +
                                          subscribedDetails!['subscription']
                                                  ['products'][0]['quantity']
                                              .toString(),
                                      context),
                                  SizedBox(height: 5),
                                  priceMrpText(
                                      "$currency${subscribedDetails!['subscription']['products'][0]['subscriptionTotal']}",
                                      "",
                                      context),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                      color: cartCardBg(context),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 1)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      builddTextbarlowmediumwblack(
                          context, "SUBSCRIPTION_STARTS_ON"),
                      builddTextbarlowRegularBlackFont14(
                        context,
                        DateFormat('dd/MM/yyyy', widget.locale ?? "en").format(
                            DateTime.parse(subscribedDetails!['subscription']
                                    ['subscriptionStartDate']
                                .toString())),
                      )
                    ],
                  ),
                ),
                subscribedDetails!['subscription']['address'] == null ||
                        subscribedDetails!['subscription']['address'] is String
                    ? Container()
                    : Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                        decoration: BoxDecoration(
                            color: cartCardBg(context),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 1)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            builddTextbarlowmediumwblack(
                                context, "DELIVERY_ADDRESS"),
                            SizedBox(height: 8),
                            builddTextbarlowRegularBlackFont14(
                              context,
                              '${subscribedDetails!['subscription']['address']['flatNo']}, ${subscribedDetails!['subscription']['address']['apartmentName']}, ${subscribedDetails!['subscription']['address']['address']}, ' +
                                  "\n${subscribedDetails!['subscription']['address']['landmark']}, ${subscribedDetails!['subscription']['address']['postalCode']}, ${subscribedDetails!['subscription']['address']['mobileNumber'].toString()}",
                            )
                          ],
                        ),
                      ),
                subscriptionStatusList.length > 0
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                            color: cartCardBg(context),
                            boxShadow: [
                              new BoxShadow(
                                  color: Colors.black12, blurRadius: 0.0),
                            ],
                            borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            )),
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 52,
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                color: cartCardBg(context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                whiteText(context, "HISTORY"),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: subscriptionStatusList.isEmpty
                                  ? 0
                                  : subscriptionStatusList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('dd/MM/yyyy',
                                                    widget.locale ?? "en")
                                                .format(DateTime.parse(
                                                    subscriptionStatusList[
                                                        index]['createdAt'])),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'BarlowRegular',
                                                color: blackText(context),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Container(
                                            width: 75,
                                            height: 22,
                                            decoration: BoxDecoration(
                                                color: subscriptionStatusList[
                                                            index]['status'] ==
                                                        "DELIVERED"
                                                    ? green.withOpacity(0.3)
                                                    : Colors.orange
                                                        .withOpacity(0.3),
                                                border: Border.all(
                                                    color:
                                                        subscriptionStatusList[
                                                                        index][
                                                                    'status'] ==
                                                                "DELIVERED"
                                                            ? green
                                                            : Colors.orange),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: textGreenPrimary(
                                                  context,
                                                  subscriptionStatusList[index]
                                                      ['status'],
                                                  subscriptionStatusList[index]
                                                              ['status'] ==
                                                          "DELIVERED"
                                                      ? textbarlowmedium12(
                                                          context)
                                                      : textbarlowmedium12Orange(
                                                          context)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    subscriptionStatusList[index]['status'] ==
                                                "PENDING" ||
                                            subscriptionStatusList[index]
                                                    ['status'] ==
                                                "DELIVERED"
                                        ? Container()
                                        : Text(
                                            subscriptionStatusList[index]
                                                ['description'],
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'BarlowRegular',
                                                color: blackText(context),
                                                fontWeight: FontWeight.w500),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Divider(),
                                    ),
                                  ],
                                );
                              })
                        ]),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
