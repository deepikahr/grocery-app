import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';

Widget appBarprimary(BuildContext context, title) {
  return GFAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      title: Text(MyLocalizations.of(context).getLocalizations(title),
          style: TextStyle(
            fontSize: 17.0,
            fontFamily: 'BarlowSemiBold',
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          )),
      centerTitle: true,
      backgroundColor: primary(context),
      iconTheme: IconThemeData(color: Colors.black87));
}

Widget appBarWhite(BuildContext context, String title, bool changeUi,
    actionTrueOrFalse, Widget actionProcess,
    {Widget titleWidget}) {
  String tempTitle = '';
  tempTitle = MyLocalizations.of(context).getLocalizations(title ?? "--");
  return GFAppBar(
    title: titleWidget != null
        ? titleWidget
        : changeUi
            ? tempTitle.substring(0, 1).toUpperCase() +
                tempTitle.substring(1, tempTitle.length)
            : Text(
                tempTitle.substring(0, 1).toUpperCase() +
                    tempTitle.substring(1, tempTitle.length),
                style: appbarText(context)),
    centerTitle: true,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1e2024)
        : lightbg,
    elevation: 0,
    iconTheme: IconThemeData(color: dark(context)),
    actions: <Widget>[actionTrueOrFalse ? actionProcess : Container()],
  );
}

Widget appBarTransparent(BuildContext context, title) {
  return GFAppBar(
      title: Text(MyLocalizations.of(context).getLocalizations(title),
          style: appbarText(context)),
      centerTitle: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF1e2024)
          : Colors.transparent,
      iconTheme: IconThemeData(color: dark(context)),
      elevation: 0);
}

Widget appBarTransparentWithoutBack(BuildContext context, title) {
  return GFAppBar(
      automaticallyImplyLeading: false,
      title: Text(MyLocalizations.of(context).getLocalizations(title),
          style: appbarText(context)),
      centerTitle: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF1e2024)
          : Colors.transparent,
      iconTheme: IconThemeData(color: dark(context)),
      elevation: 0);
}
