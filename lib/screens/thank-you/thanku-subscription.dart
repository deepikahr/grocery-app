import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class ThankyouSubscription extends StatefulWidget {
  ThankyouSubscription({Key key, this.locale, this.localizedValues});

  final Map localizedValues;
  final String locale;

  @override
  _ThankyouSubscriptionState createState() => _ThankyouSubscriptionState();
}

class _ThankyouSubscriptionState extends State<ThankyouSubscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Color(0xFFa88d2f)
                : primarybg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            thankuImage(),
            SizedBox(height: 10.0),
            orderPlaceText(context, "SUBCRIPTION_ACTIVATED"),
            SizedBox(height: 13.0),
            thankyouText(context, "THANK_YOU"),
          ],
        ),
      ),
    );
  }
}
