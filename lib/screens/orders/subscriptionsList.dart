import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/sentry-service.dart';

import 'package:readymadeGroceryApp/screens/orders/subscriptionDetails.dart';

SentryError sentryError = new SentryError();

class SubScriptionList extends StatefulWidget {
  SubScriptionList({Key key, this.locale, this.localizedValues})
      : super(key: key);

  final Map localizedValues;
  final String locale;

  @override
  _SubScriptionListState createState() => _SubScriptionListState();
}

class _SubScriptionListState extends State<SubScriptionList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          ListView.builder(
            itemCount: 6,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubscriptionDetails()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 1)
                      ]),
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
                                priceMrpText("\$89", ""),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
