import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class PaymentFailed extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;

  PaymentFailed({
    Key? key,
    this.locale,
    this.localizedValues,
  });
  @override
  _PaymentFailedState createState() => _PaymentFailedState();
}

class _PaymentFailedState extends State<PaymentFailed> {
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
            failedImage(),
            SizedBox(height: 10.0),
            orderPlaceText(context, "PAYMENT_FAILED"),
            SizedBox(height: 13.0),
            thankyouText(context, "PLEASE_TRY_AGAIN_LATER"),
            SizedBox(height: 30.0),
            InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Home(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            currentIndex: 0),
                      ),
                      (Route<dynamic> route) => false);
                },
                child: defaultButton(context, "HOME", dark(context))),
          ],
        ),
      ),
    );
  }
}
