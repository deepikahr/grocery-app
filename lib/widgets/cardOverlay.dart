import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class CardOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        alignment: Alignment.center,
        height: 171,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.black.withOpacity(0.40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Oops !',
              style: textBarlowSemiBoldwhite(),
            ),
            Text(
              'Out of stock',
              style: textBarlowSemiBoldwhite(),
            ),
          ],
        ),
      ),
    );
  }
}
