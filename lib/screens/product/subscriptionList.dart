import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/sentry-service.dart';

import 'package:readymadeGroceryApp/screens/product/modifySubscription.dart';

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
      backgroundColor: Color(0xFFF7F7F7),
      appBar: appBarPrimary(context, "SUBSCRIPTIONS"),
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
              return Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 1)
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModifySubscription()),
                            );
                          },
                          child: subscribeButton(context, "MODIFY", false),
                        ),
                        InkWell(
                          onTap: () {
                            _settingModalBottomSheet(context);
                          },
                          child: subscribeButton(context, "PAUSE", false),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 370.0,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black,
                    blurRadius: 1.0,
                  ),
                ],
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            child: ListView(children: <Widget>[
              Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  color: Colors.black,
                ),
                child: whiteText(context, "PAUSE_SUBSCRIPTION"),
              ),
              SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: regularTextatStart(context, "FROM"),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: FlatButton(
                      onPressed: () {},
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('12/12/1234'),
                            Icon(Icons.calendar_today, color: Colors.black),
                          ],
                        ),
                      )),
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: regularTextatStart(context, "TO"),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: FlatButton(
                      onPressed: () {},
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('12/12/1234'),
                            Icon(Icons.calendar_today, color: Colors.black),
                          ],
                        ),
                      )),
                ),
              ),
              SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: regularbuttonPrimary(context, "PAUSE_FOR_X_DAYS"),
              ),
              SizedBox(height: 20),
            ]),
          );
        });
  }
}
