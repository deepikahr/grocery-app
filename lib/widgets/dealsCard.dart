import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:flutter/cupertino.dart';

class DealsCard extends StatelessWidget {
  final image, title, price, currency, rating, category, offer, nullImage;
  DealsCard(
      {Key key,
      this.image,
      this.title,
      this.price,
      this.currency,
      this.rating,
      this.category,
      this.offer,
      this.nullImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = CardTheme.of(context);
    final double _defaultElevation = 1;
    final Clip _defaultClipBehavior = Clip.none;

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Material(
        type: MaterialType.card,
        color: Theme.of(context).cardColor,
        elevation: _defaultElevation ?? cardTheme.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        borderOnForeground: true,
        clipBehavior: _defaultClipBehavior ?? cardTheme.clipBehavior,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: image == null
                  ? Image.asset(nullImage)
                  : Image.network(
                      image,
                      fit: BoxFit.fill,
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: textbarlowRegularBlackb(),
                      )),
                    ],
                  ),
                  Text(
                    '$price',
                    style: textbarlowBoldgreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
