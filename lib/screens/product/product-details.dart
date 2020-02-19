import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/service/constants.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/cart-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/screens/checkout/checkout.dart';
import 'package:grocery_pro/screens/cart/mycart.dart';
import 'package:grocery_pro/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> productDetail;

  ProductDetails({Key key, this.productDetail}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

bool fav = false;
bool fav1 = false;
bool fav2 = false;
int count = 1;
int index = 0;
// bool isLoadingSubProductsList = false;
// List subProductsList = List();
String dropdownValue = 'One';

class _ProductDetailsState extends State<ProductDetails> {
  addToCart(data, buy) async {
    Map<String, dynamic> buyNowProduct = {
      'productId': data['_id'].toString(),
      'quantity': 1,
      "price": double.parse(
          widget.productDetail['variant'][index]['price'].toString()),
      "unit": widget.productDetail['variant'][index]['unit'].toString()
    };
    print('buyNowProduct, $buyNowProduct');
    if (buy == 'cart') {
      await CartService.addProductToCart(buyNowProduct).then((onValue) {
        print('value of car add product $onValue');
        try {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyCart(
                      currentIndex: 1,
                      quantity: count,
                    )),
          );
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else {
      await ProductService.getBuyNowInfor(buyNowProduct).then((onValue) {
        // print('checkout $onValue');
        try {
          Map<String, dynamic> cartItem = {
            'cart': [widget.productDetail],
            'subTotal': onValue["response_data"]["subTotal"],
            'tax': onValue["response_data"]['tax'],
            'grandTotal': onValue["response_data"]["grandTotal"],
            'deliveryCharges': onValue["response_data"]['deliveryCharges'],
          };
          if (onValue['response_code'] == 200) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Checkout(cartItem: cartItem, buy: 'buy', quantity: 1)),
            );
            print(cartItem);
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    }
  }

  @override
  void initState() {
    print(widget.productDetail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                // Container(
                //     // height: MediaQuery.of(context).size.height,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(
                //       Radius.circular(30),
                //     )),
                //     width: MediaQuery.of(context).size.width,

                //     ),
                Column(
                  children: <Widget>[
// Image.network(
//                       widget.productDetail['imageUrl'],
//                       height: 370,
//                       width: MediaQuery.of(context).size.width,
//                       fit: BoxFit.fill,
//                     ),
                    Container(
                      height: 340,
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                          // shape: BoxShape.circle,

                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10.0, // soften the shadow
                              // spreadRadius: 5.0, //extend the shadow
                              offset: Offset(
                                2.0, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  widget.productDetail['imageUrl']))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                '${widget.productDetail['title'][0].toUpperCase()}${widget.productDetail['title'].substring(1)}',
                                style: titleBold(),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 20.0),
                              child: RatingBar(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20.0,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.red,
                                  size: 15.0,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, top: 3.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              30,
                                          child: Text(
                                            '${widget.productDetail['description'][0].toUpperCase()}${widget.productDetail['description'].substring(1)}',
                                            style: TextStyle(fontSize: 10.0),
                                          ),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            right: 0.0, top: 5.0),
                                        child: Text(
                                          '${Constants.currency} ${widget.productDetail['variant'][0]['price']}',
                                          style: TextStyle(
                                              color: const Color(0xFF00BFA5),
                                              fontSize: 17.0),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 310.0,
                  left: 135.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        // height: 64.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0)),

                        // child: InkWell(
                        //   child: GFButton(
                        //   // onPressed: () => setState(() => highlight = !highlight),
                        //   boxShadow: BoxShadow(color: Colors.black),
                        //   child: Text('${widget.productDetail['variant'][0]['unit']}',
                        //       style: TextStyle(color: Colors.black)),
                        //   // color: pressAttention ? Colors.grey : Colors.blue,
                        //   type: GFButtonType.solid, onPressed: () {  },
                        //   // size: GFSize.small,
                        // ),
                        // )
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primary),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DropdownButton<String>(
                                hint: Text('Variants'),
                                disabledHint: Text('Variants'),
                                value: dropdownValue,
                                icon: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Icon(Icons.arrow_drop_down),
                                ),
                                iconSize: 24,
                                itemHeight: 49.0,
                                elevation: 16,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                underline: Container(
                                  color: Colors.white,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <String>[
                                  'One',
                                  'Two',
                                  'three',
                                  'Four'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 310.0,
                  left: 280.0,
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
          ],
        )),
      ),
      bottomNavigationBar: Container(
        height: 115,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: GFButton(
                onPressed: () {
                  addToCart(widget.productDetail, 'buy now');
                },
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
              padding: const EdgeInsets.only(left: .0, top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
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
                    width: MediaQuery.of(context).size.width - 155,
                    height: 45.0,
                    child: GFButton(
                      onPressed: () {
                        addToCart(widget.productDetail, 'cart');
                      },
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
                    // color: const Color(0xFF00BFA5),
                    // size: 1.0,
                  ),
                ],
              ),
              // color: GFColor.warning,
            ),
            // ),
          ],
        ),
      ),
      // ],
      // ),
      // ),
    );
  }
}
