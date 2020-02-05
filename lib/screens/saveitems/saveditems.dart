import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/product/product-details.dart';

class SavedItems extends StatefulWidget {
  @override
  _SavedItemsState createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  @override
  Widget build(BuildContext context) {
    Widget itemCard = GFCard(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      boxFit: BoxFit.cover,
      colorFilter: new ColorFilter.mode(
          Colors.black.withOpacity(0.67), BlendMode.darken),
      // image: Image.asset(
      //   'lib/assets/images/apple.png',
      //   // width: MediaQuery.of(context).size.width,
      //   fit: BoxFit.fitHeight,
      //   width: 80,
      //   height: 80,
      // ),

//              imageOverlay: AssetImage("lib/assets/food.jpeg"),
      // titlePosition: GFPosition.end,
      content: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Image.asset(
                      'lib/assets/images/apple.png',
                      // width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitHeight,

                      width: 80,
                      height: 80,
                    ),
                  ),
                  Positioned(
                    height: 18.0,
                    width: 60.0,
                    top: 0.0,
                    left: 0.0,
                    child: GFButtonBadge(
                      // icon: GFBadge(
                      //   // text: '6',
                      //   shape: GFBadgeShape.pills,
                      // ),
                      // fullWidthButton: true,
                      onPressed: () {},
                      text: '25% off',
                      color: Colors.deepOrange[300],
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text('Apple'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0, top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          IconData(
                            0xe913,
                            fontFamily: 'icomoon',
                          ),
                          color: const Color(0xFF00BFA5),
                          size: 11.0,
                        ),
                        Text(
                          '85/kg',
                          style: TextStyle(color: const Color(0xFF00BFA5)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 38.0, bottom: 15.0),
                    child: GFIconButton(
                      onPressed: null,
                      icon: GestureDetector(
                        onTap: () {
                          setState(() {
                            fav = !fav;
                          });
                        },
                        child: fav
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.grey,
                              ),
                      ),
                      type: GFButtonType.transparent,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );

    return Scaffold(
      appBar: GFAppBar(
        title: Text('Saved Items',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: Container(
        height: 800.0,
        child: GridView.builder(
          itemCount: 8,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Container(child: itemCard);
          },
        ),
      ),
    );
  }
}
