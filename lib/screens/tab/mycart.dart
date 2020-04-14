import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/cart-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/screens/checkout/checkout.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class MyCart extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  MyCart({Key key, this.locale, this.localizedValues}) : super(key: key);
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
      print(onValue);
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
                    new Text(
                      MyLocalizations.of(context).yourCartIsEmpty,
                      style: hintSfsemiboldred(),
                    ),
                    new Text(
                      MyLocalizations.of(context)
                          .addSomeItemsToProceedToCheckout,
                      style: textBarlowRegularBlack(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    MyLocalizations.of(context).ok,
                    style: textbarlowRegularaPrimary(),
                  ),
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
      backgroundColor: Color(0xFFFDFDFD),
      key: _scaffoldkey,
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  title: Text(
                    MyLocalizations.of(context).myCart,
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
      body: isGetTokenLoading
          ? SquareLoader()
          : token == null
              ? Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                )
              : cartItem == null
                  ? Center(
                      child: Image.asset('lib/assets/images/no-orders.png'),
                    )
                  : Container(
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
                                            bottom: 20.0, left: 10.0),
                                        child: cartItem == null
                                            ? Text(
                                                '0 ' +
                                                    MyLocalizations.of(context)
                                                        .item,
                                                style: textBarlowMediumBlack(),
                                              )
                                            : Text(
                                                '${cartItem['cart'].length}' +
                                                    MyLocalizations.of(context)
                                                        .items,
                                                style: textBarlowMediumBlack(),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cartItem == null
                                      ? 0
                                      : cartItem['cart'].length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF7F7F7),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              height: 103,
                                              width: 117,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.10),
                                                    blurRadius: 5,
                                                  )
                                                ],
                                                image: DecorationImage(
                                                  image: cartItem['cart'][i]
                                                              ['imageUrl'] ==
                                                          null
                                                      ? AssetImage(
                                                          'lib/assets/images/no-orders.png')
                                                      : NetworkImage(
                                                          cartItem['cart'][i]
                                                              ['imageUrl'],
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            flex: 6,
                                            fit: FlexFit.tight,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  cartItem['cart'][i]
                                                              ['title'] ==
                                                          null
                                                      ? " "
                                                      : cartItem['cart'][i]
                                                          ['title'],
                                                  style:
                                                      textBarlowRegularBlack(),
                                                ),
                                                // SizedBox(height: 40),
                                                Text(
                                                  cartItem['cart'][i]
                                                              ['description'] ==
                                                          null
                                                      ? " "
                                                      : cartItem['cart'][i]
                                                          ['description'],
                                                  style:
                                                      textbarlowRegularBlack(),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      currency,
                                                      style:
                                                          textbarlowBoldGreen(),
                                                    ),
                                                    Text(
                                                      cartItem['cart'][i]
                                                                  ['price'] ==
                                                              null
                                                          ? " "
                                                          : cartItem['cart'][i]
                                                                      ['price']
                                                                  .toString() +
                                                              "/" +
                                                              cartItem['cart']
                                                                          [i]
                                                                      ['unit']
                                                                  .toString(),
                                                      style:
                                                          textbarlowBoldGreen(),
                                                    ),
                                                  ],
                                                ),
                                                cartItem['cart'][i]
                                                            ['productTotal'] ==
                                                        null
                                                    ? Text("")
                                                    : Text(
                                                        " (" +
                                                            currency +
                                                            (cartItem['cart'][i]
                                                                    [
                                                                    'productTotal'])
                                                                .toString() +
                                                            ")",
                                                        style:
                                                            textbarlowBoldGreen(),
                                                      )
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              height: 133,
                                              width: 43,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF0F0F0),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(22),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      _incrementCount(i);
                                                    },
                                                    child: SvgPicture.asset(
                                                        'lib/assets/icons/plus.svg'),
                                                  ),
                                                  cartItem['cart'][i]
                                                              ['quantity'] ==
                                                          null
                                                      ? Text('0')
                                                      : Text(
                                                          '${cartItem['cart'][i]['quantity']}',
                                                          style:
                                                              textBarlowRegularBlack(),
                                                        ),
                                                  InkWell(
                                                    onTap: () {
                                                      _decrementCount(i);
                                                    },
                                                    child: SvgPicture.asset(
                                                        'lib/assets/icons/minus.svg'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
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
          ? SquareLoader()
          : token == null
              ? Container(
                  height: 120,
                )
              : isLoadingCart
                  ? SquareLoader()
                  : cartItem == null
                      ? Container(
                          height: 120.0,
                        )
                      : Container(
                          height: 120.0,
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
                                      MyLocalizations.of(context).subTotal,
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
                                    Row(
                                      children: <Widget>[
                                        Image.asset(
                                            'lib/assets/icons/sale.png'),
                                        SizedBox(width: 5),
                                        new Text(
                                          MyLocalizations.of(context).tax,
                                          style: textBarlowRegularBlack(),
                                        ),
                                      ],
                                    ),
                                    new Text(
                                      '$currency ${cartItem['tax']}',
                                      style: textbarlowBoldsmBlack(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 6),
                              SizedBox(height: 6),
                              Container(
                                height: 55,
                                margin: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFCF2D),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.29),
                                        blurRadius: 6)
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                      ),
                                      width: 115,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            MyLocalizations.of(context)
                                                .grandTotal,
                                            style: textBarlowRegularWhite(),
                                          ),
                                          new Text(
                                            '$currency ${cartItem['grandTotal']}  ',
                                            style: textbarlowBoldWhite(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Checkout(
                                                locale: widget.locale,
                                                localizedValues:
                                                    widget.localizedValues,
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
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                MyLocalizations.of(context)
                                                    .checkOut,
                                                style: textBarlowRegularBlack(),
                                              ),
                                              Icon(Icons.arrow_forward),
                                              SizedBox(width: 10)
                                            ],
                                          ),
                                        ),
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
