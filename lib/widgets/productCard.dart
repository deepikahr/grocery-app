import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:flutter/cupertino.dart';

class ProductCard extends StatelessWidget {
  final image, title, price, currency, rating, category, offer, nullImage;
  ProductCard(
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
                            style: textbarlowRegularBlackb(),
                          )),
                      Container(
                        height: 19,
//                 width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          color: Color(0xFF20C978),
                        ),
                        padding: EdgeInsets.only(left:5, right: 5),
                        child:  Row(
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
                  Text(
                    '$currency$price',
                    style: textbarlowBoldgreen(),
                  ),
                ],
              ),
            ),
          ],
        )
      )
    );
//    return Container(
//      child: GFCard(
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//        image: image == null
//            ? Image.asset(nullImage)
//            : Image.network(
//          image,
//          fit: BoxFit.contain,
//          height: 105,
//        ),
//        padding: EdgeInsets.symmetric(
//          horizontal: 12,
//        ),
//        margin: EdgeInsets.zero,
//        content: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Expanded(
//                    child: Text(
//                      title,
//                      style: textbarlowRegularBlackb(),
//                    )),
//               Container(
//                 height: 19,
////                 width: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(2)),
//                   color: Color(0xFF20C978),
//                 ),
//                  padding: EdgeInsets.only(left:5, right: 5),
//                 child:  Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     Text(rating == null ? 0 : rating,
//                         style: textBarlowregwhite()),
//                     Icon(
//                       Icons.star,
//                       color: Colors.white,
//                       size: 10,
//                     ),
//                   ],
//                 ),
//               )
//              ],
//            ),
//            Text(
//              '$currency$price',
//              style: textbarlowBoldgreen(),
//            ),
//          ],
//        ),
//      ),
//    );
  }
}
