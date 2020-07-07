import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

SentryError sentryError = new SentryError();

class TermsAndCondition extends StatefulWidget {
  TermsAndCondition(
      {Key key, this.locale, this.localizedValues, this.text, this.title})
      : super(key: key);
  final Map localizedValues;
  final String locale, title, text;
  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: textbarlowSemiBoldBlack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Container(
            margin: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.82,
            child: Text(
              widget.text,
              style: textbarlowRegularBlackd(),
            ),
          ),
        ),
      ),
    );
  }
}
