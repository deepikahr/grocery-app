import 'package:flutter/material.dart';

import 'package:readymadeGroceryApp/widgets/normalText.dart';

class CardOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Positioned(
      child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.black.withOpacity(0.40),
          ),
          child: outOfStck(context, "OOPS", "OUT_OF_STOCK")),
    );
}
