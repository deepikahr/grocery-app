import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';

import 'package:readymadeGroceryApp/style/style.dart';

class Thankyou extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
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
          children: <Widget>[
            Image.asset('lib/assets/images/thank-you.png'),
            SizedBox(height: 10.0),
            Text(
              MyLocalizations.of(context).orderPlaced,
              style: textbarlowMediumBlack(),
            ),
            SizedBox(height: 13.0),
            Text(
              MyLocalizations.of(context).thankYou + '!',
              style: textbarlowMediumlgBlack(),
            ),
            SizedBox(height: 30.0),
            GFButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currentIndex: 0,
                        languagesSelection: true,
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
              color: Colors.black,
              child: Text(
                MyLocalizations.of(context).backToHome,
                style: textbarlowMediumPrimary(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
