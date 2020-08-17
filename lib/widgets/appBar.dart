import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';

Widget appBarPrimary(BuildContext context, title) {
  return GFAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      title: Text(MyLocalizations.of(context).getLocalizations(title),
          style: textbarlowSemiBoldBlack()),
      centerTitle: true,
      backgroundColor: primary,
      iconTheme: IconThemeData(color: Colors.black));
}

Widget appBarWhite(BuildContext context, title, bool changeUi,
    actionTrueOrFalse, Widget actionProcess) {
  return GFAppBar(
    title: changeUi
        ? title
        : Text(MyLocalizations.of(context).getLocalizations(title),
            style: textbarlowSemiBoldBlack()),
    centerTitle: true,
    backgroundColor: bg,
    iconTheme: IconThemeData(color: Colors.black),
    actions: <Widget>[actionTrueOrFalse ? actionProcess : Container()],
  );
}

Widget appBarTransparent(BuildContext context, title) {
  return GFAppBar(
      title: Text(MyLocalizations.of(context).getLocalizations(title),
          style: textbarlowSemiBoldBlack()),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0);
}
