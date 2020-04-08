import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/style/style.dart';
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
  bool isLoadingCart = false,
      isIncrementLoading = false,
      isGetTokenLoading = false,
      isDecrementLoading = false,
      isUpdating = false,
      isLoading = false,
      favSelected = false;
  String token, currency;
  Map<String, dynamic> cartItem;
  int count = 1;
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getToken() async {
    if (mounted) {
      setState(() {
        isGetTokenLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await Common.getToken().then((onValue) {
      try {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
              token = onValue;
              getCartItems();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  void _incrementCount(i) {
    if (mounted)
      setState(() {
        cartItem['cart'][i]['quantity']++;
      });
    updateCart(i);
  }

  void _decrementCount(i) {
    if (cartItem['cart'][i]['quantity'] > 1) {
      if (mounted) {
        setState(() {
          cartItem['cart'][i]['quantity']--;
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
  }

  // get to cart
  getCartItems() async {
    if (mounted) {
      setState(() {
        isLoadingCart = true;
      });
    }
    await CartService.getProductToCart().then((onValue) {
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
          ),
        ),
      );
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
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
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
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  title: Text(
                    'My Cart',
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  leading: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: Icon(Icons.arrow_back)),
                ),
      body: isGetTokenLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : token == null
              ? Login()
              : cartItem == null
                  ? Center(
                      child: Image.asset('lib/assets/images/no-orders.png'),
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Container(
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
                                            ? Text(
                                                '0 Items',
                                                style: textBarlowMediumBlack(),
                                              )
                                            : Text(
                                                '${cartItem['cart'].length}' +
                                                    '  Items',
                                                style: textBarlowMediumBlack(),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cartItem == null
                                        ? 0
                                        : cartItem['cart'].length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        color: Colors.white60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  child: cartItem['cart'][i]
                                                              ['imageUrl'] ==
                                                          null
                                                      ? Image.asset(
                                                          'lib/assets/images/no-orders.png')
                                                      : Image.network(
                                                          cartItem['cart'][i]
                                                              ['imageUrl'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              bottom: 0),
                                                      child: Text(
                                                        cartItem['cart'][i]
                                                                    ['title'] ==
                                                                null
                                                            ? " "
                                                            : cartItem['cart']
                                                                [i]['title'],
                                                        style:
                                                            textBarlowRegularBlack(),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              bottom: 0.0),
                                                      child: Text(
                                                        cartItem['cart'][i][
                                                                    'discription'] ==
                                                                null
                                                            ? " "
                                                            : cartItem['cart']
                                                                    [i]
                                                                ['discription'],
                                                        style:
                                                            textbarlowRegularBlack(),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              bottom: 50.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            currency,
                                                            style: TextStyle(
                                                                color: const Color(
                                                                    0xFF00BFA5),
                                                                fontSize: 17.0),
                                                          ),
                                                          Text(
                                                            cartItem['cart'][i][
                                                                        'price'] ==
                                                                    null
                                                                ? " "
                                                                : cartItem['cart'][i]
                                                                            [
                                                                            'price']
                                                                        .toString() +
                                                                    " / " +
                                                                    cartItem['cart'][i]
                                                                            [
                                                                            'unit']
                                                                        .toString(),
                                                            style:
                                                                textbarlowBoldGreen(),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Container(
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child:
                                                              Icon(Icons.add),
                                                        ),
                                                      ),
                                                      Text(''),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 11.0),
                                                        child: Container(
                                                            child: cartItem['cart']
                                                                            [i][
                                                                        'quantity'] ==
                                                                    null
                                                                ? Text('0')
                                                                : Text(
                                                                    '${cartItem['cart'][i]['quantity']}',
                                                                    style:
                                                                        textBarlowRegularBlack(),
                                                                  )),
                                                      ),
                                                      Text(''),
                                                      InkWell(
                                                        onTap: () {
                                                          _decrementCount(i);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0),
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
      bottomNavigationBar: isGetTokenLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : token == null
              ? Container(
                  height: 110,
                )
              : isLoadingCart
                  ? Center(child: CircularProgressIndicator())
                  : cartItem == null
                      ? Container(
                          height: 120.0,
                        )
                      : Container(
                          height: 140.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      "Sub Total",
                                      style: textBarlowRegularBlack(),
                                    ),
                                    new Text(
                                      '$currency ${cartItem['subTotal']}',
                                      style: textbarlowBoldsmBlack(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      "Tax",
                                      style: textBarlowRegularBlack(),
                                    ),
                                    new Text(
                                      '$currency ${cartItem['tax']}',
                                      style: textbarlowBoldsmBlack(),
                                      // style: titleLightWhiteOSR(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, bottom: 6.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      "Delivery Charges",
                                      style: textBarlowRegularBlack(),
                                    ),
                                    new Text(
                                      '$currency ${cartItem['deliveryCharges']}',
                                      style: textbarlowBoldsmBlack(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                height: 50.0,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 20.0, end: 20.0, bottom: 5.0),
                                  child: RawMaterialButton(
                                    padding:
                                        EdgeInsetsDirectional.only(end: 15.0),
                                    fillColor: primary,
                                    constraints:
                                        const BoxConstraints(minHeight: 44.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(0.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          color: Colors.black,
                                          width: 120,
                                          margin: EdgeInsets.only(right: 90),
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 3),
                                              new Text(
                                                "Grand Total",
                                                style: textBarlowRegularWhite(),
                                              ),
                                              SizedBox(height: 1),
                                              new Text(
                                                '$currency ${cartItem['grandTotal']}  ',
                                                style: textbarlowBoldWhite(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Text(
                                          "Checkout",
                                          style: textBarlowRegularBlack(),
                                        ),
                                        Icon(Icons.arrow_forward)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Checkout(
                                            cartItem: cartItem,
                                            buy: 'cart',
                                            quantity: cartItem['cart']
                                                .length
                                                .toString(),
                                            id: cartItem['_id'].toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
    );
  }
}
