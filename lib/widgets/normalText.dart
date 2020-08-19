import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';

Widget alertText(BuildContext context, title, Icon icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        MyLocalizations.of(context).getLocalizations(title),
        style: hintSfboldBig(),
      ),
      icon != null ? icon : Container()
    ],
  );
}
