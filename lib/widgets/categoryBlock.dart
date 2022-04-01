import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class CategoryBlock extends StatelessWidget {
  final image, title;
  final bool? isHome;
  final isPath;
  CategoryBlock({Key? key, this.image, this.title, this.isPath, this.isHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        children: <Widget>[
          Container(
            width: isHome! ? 75 : 60,
            height: isHome! ? 75 : 60,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: CachedNetworkImage(
                imageUrl: isPath
                    ? Constants.imageUrlPath! + "/tr:dpr-auto,tr:w-500" + image
                    : image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Container(child: noDataImage()),
                errorWidget: (context, url, error) =>
                    Container(child: noDataImage()),
              ),
            ),
          ),
          Expanded(
              child: buildCatTitle(
                  title, true, textBarlowRegularrdarkdull(context)))
        ],
      ),
    );
  }
}
