import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

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

Widget normalText(BuildContext context, title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        MyLocalizations.of(context).getLocalizations(title),
        style: textbarlowmedium(),
      ),
    ],
  );
}

Widget walletText(BuildContext context, title, idOrderId) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: idOrderId ? textbarlowmedium() : textSMBarlowRegularrBlack(),
      ),
    ],
  );
}

Widget normalTextWithOutRow(BuildContext context, title, isCenter) {
  return Text(MyLocalizations.of(context).getLocalizations(title),
      textAlign: isCenter ? TextAlign.center : TextAlign.start,
      style: textbarlowRegularBlack());
}

Widget buildDrawer(BuildContext context, title, icon) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.0),
    child: Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ListTile(
              leading:
                  Image.asset(icon, width: 35, height: 35, color: Colors.white),
              selected: true,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              MyLocalizations.of(context).getLocalizations(title),
              style: textBarlowregwhitelg(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildDrawerLogOutLogin(BuildContext context, title, icon, isLogin) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.0),
    child: Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ListTile(
              leading: Image.asset(icon,
                  width: 35,
                  height: 35,
                  color: !isLogin ? Colors.green : Color(0xFFF44242)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              MyLocalizations.of(context).getLocalizations(title),
              style: !isLogin ? textBarlowregredGreen() : textBarlowregredlg(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildGFTypography(BuildContext context, title, isStar, isColon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: GFTypography(
      showDivider: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 2.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context)
                      .getLocalizations(title, isColon),
                  style: textBarlowRegularBlack()),
              TextSpan(
                text: isStar ? " * " : ' ',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildGFTypographyOtp(BuildContext context, title, text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: MyLocalizations.of(context).getLocalizations(title),
              style: textBarlowRegularBlack()),
          TextSpan(
            text: text == null ? " " : text,
            style: textBarlowMediumGreen(),
          ),
        ],
      ),
    ),
  );
}

Widget buildResentOtp(BuildContext context, title, isResentOtpLoading) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Text(
          MyLocalizations.of(context).getLocalizations(title),
          style: textBarlowRegularBlack(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: isResentOtpLoading ? SquareLoader() : Container(),
      ),
    ],
  );
}

Widget buildBoldText(BuildContext context, title) {
  return GFTypography(
    showDivider: false,
    child: Text(MyLocalizations.of(context).getLocalizations(title),
        style: textbarlowMediumBlack()),
  );
}

Widget buildGFTypographyFogotPass(BuildContext context, title, isStyle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: MyLocalizations.of(context).getLocalizations(title) + "?",
              style: isStyle
                  ? textbarlowRegularaPrimary()
                  : textbarlowRegularBlackFont()),
          TextSpan(
            text: '',
            style: TextStyle(color: primary),
          ),
        ],
      ),
    ),
  );
}

Widget profileText(BuildContext context, title) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: Color(0xFFF7F7F7),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 9.0, left: 20.0, right: 20.0),
          child: Text(
            MyLocalizations.of(context).getLocalizations(title),
            style: textBarlowMediumBlack(),
          ),
        ),
      ],
    ),
  );
}

Widget subCatTab(BuildContext context, title, Color color) {
  return Container(
    height: 35,
    padding: EdgeInsets.only(left: 25, right: 25, top: 8),
    margin: EdgeInsets.only(right: 15),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: textbarlowMediumBlackm(),
    ),
  );
}

Widget buildBadge(BuildContext context, title, subTitle) {
  return Positioned(
    child: Stack(
      children: <Widget>[
        Container(
          width: 61,
          height: 18,
          decoration: BoxDecoration(
              color: Color(0xFFFFAF72),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
        ),
        Text(
          " " +
              title +
              "% " +
              MyLocalizations.of(context).getLocalizations(subTitle),
          style: hintSfboldwhitemed(),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
