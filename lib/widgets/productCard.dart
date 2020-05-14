import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:flutter/cupertino.dart';

class ProductCard extends StatelessWidget {
  final image,
      title,
      price,
      currency,
      rating,
      category,
      offer,
      unit,
      buttonName;
  final bool token;
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
      this.rating,
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
              child: Image.network(
                Constants.IMAGE_URL_PATH + "tr:dpr-auto,tr:w-500" + image,
                fit: BoxFit.fill,
                height: 120,
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
                        ),
                      ),
                      Container(
                        height: 19,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          color: Color(0xFF20C978),
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(rating == null ? '0' : rating,
                                style: textBarlowregwhite()),
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
                      Expanded(
                        child: Text(
                          '$currency$price/$unit',
                          style: textbarlowBoldgreen(),
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
