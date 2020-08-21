import 'package:flutter/material.dart';

import 'package:readymadeGroceryApp/widgets/normalText.dart';

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
          child: outOfStck(context, "OOPS", "OUT_OF_STOCK")),
    );
  }
}
