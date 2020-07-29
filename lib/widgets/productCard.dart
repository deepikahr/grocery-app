import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:flutter/cupertino.dart';

class ProductCard extends StatelessWidget {
  final currency;
  final double dealPercentage;
  final Map productData;
  final List variantList;
  final String locale;
  final Map localizedValues;
  ProductCard(
      {Key key,
      this.currency,
      this.dealPercentage,
      this.productData,
      this.variantList,
      this.locale,
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
                productData['filePath'] != null
                    ? Constants.imageUrlPath +
                        "/tr:dpr-auto,tr:w-500" +
                        productData['filePath']
                    : productData['imageUrl'],
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
                          '${productData['title'][0].toUpperCase()}${productData['title'].substring(1)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textbarlowRegularBlackb(),
                        ),
                      ),
                      productData['averageRating'] == null ||
                              productData['averageRating'] == 0 ||
                              productData['averageRating'] == '0'
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
                                  Text(
                                      productData['averageRating']
                                          .toStringAsFixed(1),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dealPercentage != null
                                ? '$currency${(productData['variant'][0]['price'] - (productData['variant'][0]['price'] * dealPercentage) / 100).toDouble().toStringAsFixed(2)}'
                                : '$currency${(productData['variant'][0]['price']).toDouble().toStringAsFixed(2)}',
                            style: textbarlowBoldgreen(),
                          ),
                          SizedBox(width: 3),
                          dealPercentage == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    '$currency${productData['variant'][0]['price'].toDouble().toStringAsFixed(2)}',
                                    style: barlowregularlackstrike(),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          '${productData['variant'][0]['unit']}',
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
