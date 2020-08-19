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
