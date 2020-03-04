import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/service/constants.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class DropDown extends StatefulWidget {
  final Map<String, dynamic> productDetail;
  DropDown({Key key, this.productDetail}) : super(key: key);
  @override
  _DropDownState createState() => DropDownState();
}
