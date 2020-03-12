import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/badge/gf_button_badge.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/shape/gf_button_shape.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:grocery_pro/service/cart-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/screens/checkout/checkout.dart';
import 'package:getflutter/getflutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class MyCart extends StatefulWidget {
  final int quantity;
  final int currentIndex;
  MyCart({Key key, this.quantity, this.currentIndex}) : super(key: key);
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool isLoadingCart = false;
  bool isIncrementLoading = false;
  bool isDecrementLoading = false;
  bool isUpdating = false;
  @override
  void initState() {
    super.initState();
    // getResult();
    print('the world is not enough');
    getCartItems();
  }

  Map<String, dynamic> cartItem;
  bool isLoading = false, favSelected = false;
  int count = 1;
  // getResult() async {
  //   _currentLocation = await _location.getLocation();
  // }

  void _incrementCount(i) {
    if (mounted)
      setState(() {
        cartItem['cart'][i]['quantity']++;
      });
    updateCart(i);
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          width: 270.0,
          child: new AlertDialog(
            // title: new Text('Thank You ...!!'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text('Item Quantity Incremented...!'),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _decrementCount(i) {
    if (cartItem['cart'][i]['quantity'] > 1) {
      if (mounted) {
        setState(() {
          cartItem['cart'][i]['quantity']--;
          // getCartItems();
          updateCart(i);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          deleteCart(i);
        });
      }
    }
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          width: 270.0,
          child: new AlertDialog(
            // title: new Text('Thank You ...!!'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text('Item Quantity Decremented...!'),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );

    // getCartItems();
  }

  // update cart
  updateCart(i) async {
    Map<String, dynamic> body = {
      'cartId': cartItem['_id'],
      'productId': cartItem['cart'][i]['productId'],
      'quantity': cartItem['cart'][i]['quantity']
    };
    if (mounted) {
      setState(() {
        isUpdating = true;
      });
    }

    await CartService.updateProductToCart(body).then((onValue) {
      try {
        if (mounted) {
          setState(() {
            cartItem = onValue['response_data'];
            isUpdating = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
    print(cartItem);
    // getCartItems();
  }

  // get to cart
  getCartItems() async {
    if (mounted) {
      setState(() {
        isLoadingCart = true;
      });
    }
    await CartService.getProductToCart().then((onValue) {
      print('cartlist $onValue');
      try {
        if (onValue['response_data'] == 'You have not added items to cart') {
          if (mounted) {
            setState(() {
              cartItem = null;
              isLoadingCart = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              cartItem = onValue['response_data'];
              if (cartItem['grandTotal'] != null) {
                isLoadingCart = false;
                // void.dispose();
              }
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
    print('cartItem $cartItem');
  }

  onProceed() {
    if (cartItem == null) {
      showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            width: 270.0,
            child: new AlertDialog(
              // title: new Text('Thank You ...!!'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text('Your Cart Is Empty.'),
                    new Text('Add Some Items To Proceed To Checkout.'),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Checkout(
                    cartItem: cartItem,
                    buy: 'cart',
                    quantity: cartItem['cart'].length.toString(),
                    id: cartItem['_id'].toString(),
                  )));
    }
  }

  //delete from cart
  deleteCart(i) async {
    Map<String, dynamic> body = {
      'cartId': cartItem['_id'],
      'productId': cartItem['cart'][i]['productId'],
    };
    await CartService.deleteDataFromCart(body).then((onValue) {
      try {
        if (onValue['response_data'] == 'You have not added items to cart') {
          if (mounted) {
            setState(() {
              cartItem = null;
            });
          }
          getCartItems();
        } else {
          if (mounted) {
            setState(() {
              cartItem = onValue['response_data'];
            });
          }
        }
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Container(
              width: 270.0,
              child: new AlertDialog(
                // title: new Text('Thank You ...!!'),
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      new Text('Item Deleted...!'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
    // updateCart(i);
    getCartItems();
  }

  deleteAllCart(cartId) async {
    await CartService.deleteAllDataFromCart(cartId).then((onValue) {
      try {
        if (onValue['response_data'] == 'Cart deleted successfully') {
          if (mounted) {
            setState(() {
              cartItem = null;
            });
          }
          getCartItems();
        } else {
          if (mounted) {
            setState(() {
              cartItem = onValue['response_data'];
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
      // Navigator.pop(context);
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: GFAppBar(
        title: Text('My Cart',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
      body:
          // GFFloatingWidget(
          // showblurness: isLoadingCart ? false : true,
          // blurnessColor:
          //     isLoadingCart ? Colors.white : Colors.black.withOpacity(0.3),
          // verticalPosition: 70,
          // child:
          isLoadingCart
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: <Widget>[
                    cartItem == null
                        ? Center(
                            child:
                                Image.asset('lib/assets/images/no-orders.png'))
                        : SizedBox(height: 20),
                    Container(
                      color: Colors.grey[100],
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, left: 10.0),
                                  child: cartItem == null
                                      ? Text('0 Items')
                                      : Text(
                                          '${cartItem['cart'].length}' +
                                              '  Items',
                                          style: comments(),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white54,
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: cartItem == null
                                  // &&
                                  // cartItem['cart'].length == null
                                  ? 0
                                  : cartItem['cart'].length,
                              itemBuilder: (BuildContext context, int i) {
                                return GFListTile(
                                  avatar: Container(
                                    height: 100,
                                    width: 100,
                                    child: cartItem['cart'][i]['imageUrl'] ==
                                            null
                                        ? Image.asset(
                                            'lib/assets/images/no-orders.png')
                                        : Image.network(
                                            cartItem['cart'][i]['imageUrl'],
                                          ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 18.0, right: 25.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 32.0),
                                          child: Text(
                                            cartItem['cart'][i]['title'] == null
                                                ? " "
                                                : cartItem['cart'][i]['title'],
                                            style: heading(),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, bottom: 30.0),
                                          child: Text(
                                            cartItem['cart'][i]
                                                        ['discription'] ==
                                                    null
                                                ? " "
                                                : cartItem['cart'][i]
                                                    ['discription'],
                                            style: labelStyle(),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 32.0),
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
                                                cartItem['cart'][i]['price'] ==
                                                        null
                                                    ? " "
                                                    : cartItem['cart'][i]
                                                                ['price']
                                                            .toString() +
                                                        " / " +
                                                        cartItem['cart'][i]
                                                                ['unit']
                                                            .toString(),
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFF00BFA5),
                                                    fontSize: 17.0),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: .0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            height: 132,
                                            width: 30,
                                            child: Column(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    _incrementCount(i);
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0)),
                                                    child: Icon(Icons.add),
                                                  ),
                                                ),
                                                Text(''),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 14.0),
                                                  child: Container(
                                                      child: cartItem['cart'][i]
                                                                  [
                                                                  'quantity'] ==
                                                              null
                                                          ? Text('0')
                                                          : Text(
                                                              '${cartItem['cart'][i]['quantity']}',
                                                            )),
                                                ),
                                                Text(''),
                                                InkWell(
                                                  onTap: () {
                                                    _decrementCount(i);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0)),
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      color: Colors.white54,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 6.0, top: 6.0),
                                        child: Image.asset(
                                            'lib/assets/images/apple.png'),
                                      )),
                                    ],
                                  ),
                                  Positioned(
                                    height: 26.0,
                                    width: 117.0,
                                    top: 77.0,
                                    // left: 20.0,
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
                              // Column(
                              //   children: <Widget>[
                              //     Image.asset('lib/assets/images/grape.png'),
                              //   ],
                              // ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 32.0),
                                    child: Text(
                                      'Applee',
                                      style: heading(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 30.0),
                                    child: Text(
                                      '100% Organic',
                                      style: labelStyle(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 32.0),
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
                                          style: TextStyle(
                                              color: const Color(0xFF00BFA5),
                                              fontSize: 17.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: .0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20.0)),
                              height: 132,
                              width: 30,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Icon(Icons.add),
                                  ),
                                  Text(''),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14.0),
                                    child: Container(child: Text('1')),
                                  ),
                                  Text(''),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200.0,
                    ),
                  ],
                ),
      // ),
      bottomNavigationBar: isLoadingCart
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: .0, top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
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
                                  child: Text('Grand Total :'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
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
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
                                        child: cartItem == null
                                            ? Text("  0")
                                            : Text(
                                                '${cartItem['grandTotal']}',
                                                style: TextStyle(
                                                    color: const Color(
                                                        0xFF00BFA5)),
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
                            onPressed: onProceed,
                            // () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Checkout(
                            //               cartItem: cartItem,
                            //               buy: 'cart',
                            //               quantity: cartItem['cart']
                            //                   .length
                            //                   .toString(),
                            //               id: cartItem['_id'].toString(),
                            //             )),
                            //   );
                            // },
                            shape: GFButtonShape.square,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Proceed . ',
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
              ),
            ),
    );
  }
}
