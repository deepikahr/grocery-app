import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:readymadeGroceryApp/screens/authe/otp.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class Verification extends StatefulWidget {
  Verification({Key key, this.title, this.locale, this.localizedValues})
      : super(key: key);
  final String title, locale;
  final Map<String, Map<String, String>> localizedValues;

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Text(
          MyLocalizations.of(context).welcome,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 15.0, bottom: 30.0),
              child: Text(
                MyLocalizations.of(context).letsgetstarted + "!",
                style: boldHeading(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: GFTypography(
                showDivider: false,
                child: Text(
                  MyLocalizations.of(context).enterYourContactNumber,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "+91",
                    labelStyle: labelStyle(),
                    prefixText: '+91',
                    contentPadding: EdgeInsets.all(10),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              child: GFButton(
                color: primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Otp(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                      ),
                    ),
                  );
                },
                text: 'Continue',
                textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
