import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';

Widget appBarPrimary(BuildContext context, title) {
  return GFAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      title: Text(MyLocalizations.of(context)!.getLocalizations(title),
          style: textbarlowSemiBoldBlack(context)),
      centerTitle: true,
      backgroundColor: primary(context),
      iconTheme: IconThemeData(color: dark(context)));
}

Widget appBarPrimarynoradius(BuildContext context, title) {
  return GFAppBar(
      title: Text(MyLocalizations.of(context)!.getLocalizations(title),
          style: textbarlowSemiBoldBlack(context)),
      centerTitle: true,
      backgroundColor: primary(context),
      iconTheme: IconThemeData(color: dark(context)));
}

Widget appBarWhite(BuildContext context, title, bool changeUi,
    actionTrueOrFalse, Widget? actionProcess) {
  return GFAppBar(
    title: changeUi
        ? title
        : Text(MyLocalizations.of(context)!.getLocalizations(title),
            style: textbarlowSemiBoldBlack(context)),
    centerTitle: true,
    backgroundColor: bg(context),
    elevation: 0,
    iconTheme: IconThemeData(color: dark(context)),
    actions: actionTrueOrFalse ? [actionProcess!] : [Container()],
  );
}

Widget appBarTransparent(BuildContext context, title) {
  return GFAppBar(
      title: Text(MyLocalizations.of(context)!.getLocalizations(title),
          style: textbarlowSemiBoldBlack(context)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: dark(context)),
      elevation: 0);
}

Widget appBarTransparentWithBackTab(
    BuildContext context, title, Function()? onPress) {
  return GFAppBar(
    title: Text(MyLocalizations.of(context)!.getLocalizations(title),
        style: textbarlowSemiBoldBlack(context)),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: dark(context)),
    elevation: 0,
    leading: InkWell(
        onTap: onPress,
        child: Platform.isIOS
            ? Icon(Icons.arrow_back_ios)
            : Icon(Icons.arrow_back)),
  );
}

Widget appBarTransparentWithoutBack(BuildContext context, title) {
  return GFAppBar(
      automaticallyImplyLeading: false,
      title: Text(MyLocalizations.of(context)!.getLocalizations(title),
          style: appbarText(context)),
      centerTitle: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF1e2024)
          : Colors.transparent,
      iconTheme: IconThemeData(color: dark(context)),
      elevation: 0);
}

Widget appBarPrimarynoradiusWithContent(BuildContext context, title,
    bool changeUi, actionTrueOrFalse, Widget? actionProcess) {
  return GFAppBar(
    title: changeUi
        ? title
        : Expanded(
            child: Text(
              MyLocalizations.of(context)!.getLocalizations(title),
              style: textbarlowSemiBoldBlack(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
    centerTitle: false,
    automaticallyImplyLeading: true,
    titleSpacing: 0,
    backgroundColor: primary(context),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    actions: actionTrueOrFalse ? [actionProcess!] : [Container()],
  );
}
