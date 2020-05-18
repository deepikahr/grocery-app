import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:flutter/cupertino.dart';

class ProductCard extends StatelessWidget {
  final image, title, currency, rating, category, offer, unit, buttonName;
  final double price, dealPercentage;
  final bool token, isPath;
  final Map productList;
  final List variantList;
  final String locale;
  final Map<String, Map<String, String>> localizedValues;
  ProductCard(
      {Key key,
      this.unit,
      this.image,
      this.title,
      this.price,
      this.currency,
      this.isPath,
      this.rating,
      this.dealPercentage,
      this.category,
      this.offer,
      this.buttonName,
      this.productList,
      this.variantList,
      this.locale,
      this.token,
      this.localizedValues})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = CardTheme.of(context);
    final double _defaultElevation = 1;
    final Clip _defaultClipBehavior = Clip.none;

    return Container(
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
              child: Image.network(
                isPath
                    ? Constants.IMAGE_URL_PATH + "tr:dpr-auto,tr:w-500" + image
                    : image,
                fit: BoxFit.cover,
                height: 123,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textbarlowRegularBlackb(),
                        ),
                      ),
                      rating == null || rating == 0 || rating == '0'
                          ? Container()
                          : Container(
                              // height: 19,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                color: Color(0xFF20C978),
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(rating, style: textBarlowregwhite()),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dealPercentage != null
                                ? '$currency${(price - (price * dealPercentage) / 100).toDouble().toStringAsFixed(2)}'
                                : '$currency${(price).toDouble().toStringAsFixed(2)}',
                            style: textbarlowBoldgreen(),
                          ),
                          SizedBox(width: 3),
                          dealPercentage == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    '$currency${price.toDouble().toStringAsFixed(2)}',
                                    style: barlowregularlackstrike(),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          '$unit',
                          style: barlowregularlack(),
                        ),
                      ),
                    ],
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
