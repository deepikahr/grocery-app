import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/sentry-service.dart';

import 'package:readymadeGroceryApp/style/style.dart';

SentryError sentryError = new SentryError();

class SubscriptionDetails extends StatefulWidget {
  SubscriptionDetails({Key key, this.locale, this.localizedValues})
      : super(key: key);

  final Map localizedValues;
  final String locale;

  @override
  _SubscriptionDetailsState createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: appBarPrimarynoradius(context, "DETAILS"),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                        flex: 4,
                        child: Image.asset(
                          "lib/assets/images/product.png",
                          width: 117,
                          height: 113,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          normallText(context, "Nandini"),
                          SizedBox(height: 5),
                          regularTextatStart(context, "500ml"),
                          regularTextblack87(context, "SUBSCRIBED_DAILY"),
                          Row(
                            children: [
                              Text('QTY : '),
                              regularTextblack87(context, "1"),
                            ],
                          ),
                          priceMrpText("\$89", "",context),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: textbarlowmediumwblack(context),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Delivery Address AddressAdd ressAddressAd dressAddressAddr essAddressAddress',
                  style: textbarlowRegularBlackFont14(context),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 0.0,
                  ),
                ],
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
            child: ListView(children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    whiteText(context, "MON"),
                    Row(
                      children: [
                        Image.asset(
                          'lib/assets/icons/back.png',
                          color: Colors.white,
                          width: 20,
                          height: 14,
                        ),
                        SizedBox(width: 20),
                        Image.asset(
                          'lib/assets/icons/front.png',
                          color: Colors.white,
                          width: 20,
                          height: 14,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    normallText(context, "Day1"),
                    Container(
                      width: 75,
                      height: 22,
                      decoration: BoxDecoration(
                          color: green.withOpacity(0.3),
                          border: Border.all(color: green),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Delivered',
                            style: textbarlowmedium12(context),
                          ),
                          Icon(
                            Icons.check,
                            color: green,
                            size: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    normallText(context, "Day1"),
                    Container(
                      width: 75,
                      height: 22,
                      decoration: BoxDecoration(
                          color: green.withOpacity(0.3),
                          border: Border.all(color: green),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Delivered',
                            style: textbarlowmedium12(context),
                          ),
                          Icon(
                            Icons.check,
                            color: green,
                            size: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    normallText(context, "Day2"),
                    Container(
                      width: 75,
                      height: 22,
                      decoration: BoxDecoration(
                          color: green.withOpacity(0.3),
                          border: Border.all(color: green),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Delivered',
                            style: textbarlowmedium12(context),
                          ),
                          Icon(
                            Icons.check,
                            color: green,
                            size: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    normallText(context, "Day3"),
                    Container(
                      width: 75,
                      height: 22,
                      decoration: BoxDecoration(
                          color: star.withOpacity(0.3),
                          border: Border.all(color: star),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Paused',
                            style: textbarlowmedium12star(context),
                          ),
                          Icon(
                            Icons.pause,
                            color: star,
                            size: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
