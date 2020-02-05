import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/store/store.dart';
import 'package:grocery_pro/style/style.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

bool fav = false;
bool fav1 = false;
bool fav2 = false;

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  // height: 400.0,
                  // width: 600,
                  child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 38.0,
                ),
                child: Image.asset('lib/assets/images/product.png'),
              )),
              Positioned(
                  top: 40.0,
                  left: 15.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Store()),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                top: 330.0,
                left: 45.0,
                child: Container(
                  height: 25.0,
                  width: 60.0,
                  child: GFButton(
                    onPressed: () {},
                    boxShadow: BoxShadow(color: Colors.black),
                    child: Text('500gm', style: TextStyle(color: Colors.black)),
                    color: GFColor.light,
                    type: GFButtonType.solid,
                    // size: GFSize.small,
                  ),
                ),
              ),
              Positioned(
                top: 330.0,
                left: 115.0,
                child: Container(
                  height: 25.0,
                  width: 60.0,
                  child: GFButton(
                    onPressed: () {},
                    boxShadow: BoxShadow(color: Colors.black),
                    child: Text('1kg', style: TextStyle(color: Colors.black)),
                    color: GFColor.light,
                    type: GFButtonType.solid,
                    // size: GFSize.small,
                  ),
                ),
              ),
              Positioned(
                top: 330.0,
                left: 185.0,
                child: Container(
                  height: 25.0,
                  width: 60.0,
                  child: GFButton(
                    onPressed: () {},
                    // focusColor: Colors.red,
                    highlightColor: Colors.red,
                    // hoverColor: Colors.red,

                    boxShadow: BoxShadow(color: Colors.black),
                    child: Text('2kg', style: TextStyle(color: Colors.black)),
                    color: GFColor.light,
                    type: GFButtonType.solid,
                    // size: GFSize.small,
                  ),
                ),
              ),
              Positioned(
                top: 320.0,
                left: 250.0,
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          blurRadius: 1.0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)),
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
                              size: 25.0,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 25.0,
                            ),
                    ),
                    type: GFButtonType.transparent,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        'Oranges',
                        style: titleBold(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        '100% Organic',
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Image.asset('lib/assets/icons/rupee.png'),
                          Text(
                            '85/kg',
                            style: TextStyle(
                                color: const Color(0xFF00BFA5), fontSize: 17.0),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 38.0, left: 100.0),
                        child: RatingBar(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.red,
                            size: 15.0,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: GFButton(
              onPressed: () {},
              child: Text(
                "Buy now",
              ),
              type: GFButtonType.outline,
              color: GFColor.dark,
              size: GFSize.large,
              blockButton: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 0.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 105.0,
                  height: 45.0,
                  child: GFButton(
                    onPressed: () {},
                    // text: 'Warning',
                    color: GFColor.dark,
                    shape: GFButtonShape.square,

                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text('1kg:'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Icon(
                                  IconData(
                                    0xe913,
                                    fontFamily: 'icomoon',
                                  ),
                                  color: Colors.white,
                                  size: 11.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: Text(
                                  '123',
                                  // style: TextStyle(color: const Color(0xFF00BFA5)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 210.0,
                  height: 45.0,
                  child: GFButton(
                    onPressed: () {},
                    shape: GFButtonShape.square,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Add to cart ',
                          style: TextStyle(color: Colors.black),
                        ),
                        Icon(
                          IconData(
                            0xe911,
                            fontFamily: 'icomoon',
                          ),
                          // color: const Color(0xFF00BFA5),
                          // size: 1.0,
                        ),
                      ],
                    ),
                    color: GFColor.warning,
                  ),
                )
              ],
            ),
          ),
        ],
      )),
      // bottomNavigationBar: BottomNavigationBar(items: null),
    );
  }
}
