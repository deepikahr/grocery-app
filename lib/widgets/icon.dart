import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

Widget icon(BuildContext context, icon, cartData) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: GFIconBadge(
      child: Icon(
        IconData(
          icon,
          fontFamily: 'icomoon',
        ),
      ),
      counterChild: (cartData == null || cartData == 0)
          ? Container()
          : GFBadge(
              child: Text(
                '${cartData.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontFamily: "bold", fontSize: 11),
              ),
              shape: GFBadgeShape.circle,
              color: Colors.red,
              size: 25,
            ),
    ),
  );
}
