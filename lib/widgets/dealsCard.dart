import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DealsCard extends StatelessWidget {
  final image, title, price, currency, rating, category, offer, nullImage;
  final bool? isPath;
  DealsCard(
      {Key? key,
      this.image,
      this.title,
      this.price,
      this.currency,
      this.isPath,
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
        elevation:
            _defaultElevation.isNaN ? cardTheme.elevation! : _defaultElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        borderOnForeground: true,
        clipBehavior: _defaultClipBehavior.index.isNaN
            ? cardTheme.clipBehavior!
            : _defaultClipBehavior,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: isPath!
                    ? Constants.imageUrlPath! + "/tr:dpr-auto,tr:w-500" + image
                    : image,
                imageBuilder: (context, imageProvider) => Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 250,
                    child: noDataImage()),
                errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 250,
                    child: noDataImage()),
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
                          child: buildCatTitle(
                              '${title[0].toUpperCase()}${title.substring(1)}',
                              false,
                              textBarlowRegularrdarkdull(context)))
                    ],
                  ),
                  priceMrpText(price, null, context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
