import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/orders/tab.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class Thankyou extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  Thankyou({Key key, this.locale, this.localizedValues});
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
        decoration: BoxDecoration(color: primary),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            thankuImage(),
            SizedBox(height: 10.0),
            orderPlaceText(context, "ORDER_PLACED"),
            SizedBox(height: 13.0),
            thankyouText(context, "THANK_YOU"),
            SizedBox(height: 30.0),
            InkWell(
                onTap: () {
                  var reuslt = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => OrdersTab(
                        // locale: widget.locale,
                        // localizedValues: widget.localizedValues,
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
                },
                child: defaultButton(context, "ORDERS", Colors.black)),
          ],
        ),
      ),
    );
  }
}
