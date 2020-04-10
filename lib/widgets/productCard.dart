import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';

class ProductCard extends StatelessWidget {
  final image, title, price, currency, rating, category, offer, nullImage;
  ProductCard({Key key, this.image, this.title, this.price, this.currency, this.rating,
    this.category, this.offer, this.nullImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFCard(
      height: 160,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(12.0)),
        image: image == null ?
        Image.asset(nullImage) : Image.network(
          image,
          fit: BoxFit.contain,
          height: 105,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12,),
        margin: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text(title,  style: textbarlowRegularBlackb(),)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('4.5 ',style: textbarlowRegularBlackb()),
                    Icon(Icons.star, color: primary, size: 18,),
                  ],
                )
              ],
            ),
            Text('$currency $price', style: textbarlowBoldgreen(),),
          ],
        ),
    );
  }
}
