import 'package:flutter/material.dart';
import 'package:grocery_pro/style/style.dart';

class CategoryBlock extends StatelessWidget {
  final image, title;
  CategoryBlock({Key key, this.image, this.title}) : super(key: key);

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
              border: Border.all(
                  color: Colors.black.withOpacity(0.20)),
            ),
            child: Image.network(
              image,
              scale: 8,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: textBarlowRegularrdarkdull(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
