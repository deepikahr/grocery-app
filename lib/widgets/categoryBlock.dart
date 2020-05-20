import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class CategoryBlock extends StatelessWidget {
  final image, title;
  final isPath;
  CategoryBlock({Key key, this.image, this.title, this.isPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: EdgeInsets.only(right: 16),
      child: Column(
        children: <Widget>[
          Container(
            width: 65,
            height: 68,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Colors.black.withOpacity(0.20)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                isPath
                    ? Constants.IMAGE_URL_PATH + "tr:dpr-auto,tr:w-500" + image
                    : image,
                scale: 8,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: textBarlowRegularrdarkdull(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
