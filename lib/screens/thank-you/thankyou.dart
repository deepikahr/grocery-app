import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/orders/orderTab.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class Thankyou extends StatefulWidget {
  Thankyou({
    Key? key,
    this.locale,
    this.localizedValues,
    this.isSubscription = false,
    this.isWallet = false,
  });

  final Map? localizedValues;
  final String? locale;
  final bool isSubscription, isWallet;

  @override
  _ThankyouState createState() => _ThankyouState();
}

class _ThankyouState extends State<Thankyou> {
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
            widget.isWallet ? thankuImageWallet() : thankuImage(),
            SizedBox(height: 10.0),
            orderPlaceText(
                context,
                (widget.isSubscription
                    ? "SUBCRIPTION_ACTIVATED"
                    : widget.isWallet
                        ? "MONEY_ADDED_TO_WALLET"
                        : "ORDER_PLACED")),
            widget.isWallet ? Container() : SizedBox(height: 13.0),
            widget.isWallet ? Container() : thankyouText(context, "THANK_YOU"),
            SizedBox(height: 30.0),
            InkWell(
                onTap: () {
                  if (widget.isSubscription || widget.isWallet) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Home(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            currentIndex: 0,
                          ),
                        ),
                        (Route<dynamic> route) => false);
                  } else {
                    var reuslt = Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => OrdersTab(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ),
                      ),
                    );
                    reuslt.then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Home(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            currentIndex: 0,
                          ),
                        ),
                        (Route<dynamic> route) => false));
                  }
                },
                child: defaultButton(
                    context,
                    (widget.isSubscription || widget.isWallet
                        ? "HOME"
                        : "ORDERS"),
                    dark(context))),
          ],
        ),
      ),
    );
  }
}
