import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/screens/checkout/checkout.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  String quantityUpdateType = '+';
  Map<String, dynamic> cartItem;
  int count = 1;
  double bottomBarHeight = 124;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void _incrementCount(i) {
    quantityUpdateType = '+';
    if (mounted)
      setState(() {
        cartItem['cart'][i]['quantity']++;
      });
    updateCart(i);
  }

  void _decrementCount(i) {
    quantityUpdateType = '-';
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
        cartItem['cart'][i]['isQuantityUpdating'] = true;
      });
    }
    await CartService.updateProductToCart(body).then((onValue) {
      try {
        if (mounted) {
          if (onValue['response_code'] == 400) {
            cartItem['cart'][i]['quantity']--;
            cartItem['cart'][i]['isQuantityUpdating'] = false;
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
                            onValue['response_data'],
                            style: hintSfsemiboldred(),
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
            cartItem = onValue['response_data'];
          }
          setState(() {
            isUpdating = false;
            cartItem['cart'][i]['isQuantityUpdating'] = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            cartItem = null;
            isUpdating = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          cartItem = null;
          isUpdating = false;
        });
      }
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
        _refreshController.refreshCompleted();
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
                bottomBarHeight = 124;
                if (cartItem['deliveryCharges'] != 0) {
                  bottomBarHeight = bottomBarHeight + 20;
                }
                if (cartItem['tax'] != 0) {
                  bottomBarHeight = bottomBarHeight + 20;
                }
                if (cartItem['couponInfo'] != null) {
                  bottomBarHeight = bottomBarHeight + 20;
                }
                isLoadingCart = false;
              }
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            cartItem = null;
            isLoadingCart = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          cartItem = null;
          isLoadingCart = false;
        });
      }
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
      var result = Navigator.push(
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
      result.then((value) {
        getCartItems();
      });
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
        if (mounted) {
          setState(() {
            cartItem = null;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          cartItem = null;
        });
      }
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
        if (mounted) {
          setState(() {
            cartItem = null;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          cartItem = null;
        });
      }
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
                  isCart: true,
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
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 20.0, right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      cartItem == null
                                          ? Text(
                                              '0 ' +
                                                  MyLocalizations.of(context)
                                                      .item,
                                              style: textBarlowMediumBlack(),
                                            )
                                          : Text(
                                              '(${cartItem['cart'].length}) ' +
                                                  MyLocalizations.of(context)
                                                      .items,
                                              style: textBarlowMediumBlack(),
                                            ),
                                      InkWell(
                                        onTap: () {
                                          deleteAllCart(cartItem['_id']);
                                        },
                                        child: Text(
                                          MyLocalizations.of(context).clearCart,
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
                                      margin: EdgeInsets.only(bottom: 5),
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
                                              height: 90,
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
                                                  fit: BoxFit.cover,
                                                  image: cartItem['cart'][i][
                                                                  'filePath'] ==
                                                              null &&
                                                          cartItem['cart'][i][
                                                                  'imageUrl'] ==
                                                              null
                                                      ? AssetImage(
                                                          'lib/assets/images/no-orders.png')
                                                      : NetworkImage(
                                                          cartItem['cart'][i][
                                                                      'filePath'] ==
                                                                  null
                                                              ? cartItem['cart']
                                                                      [i]
                                                                  ['imageUrl']
                                                              : Constants
                                                                      .IMAGE_URL_PATH +
                                                                  "tr:dpr-auto,tr:w-500" +
                                                                  cartItem['cart']
                                                                          [i][
                                                                      'filePath'],
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
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      textBarlowRegularBlack(),
                                                ),
                                                SizedBox(height: 10),
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
                                                          : cartItem['cart'][i][
                                                                  'productTotal']
                                                              .toDouble()
                                                              .toStringAsFixed(
                                                                  2)
                                                              .toString(),
                                                      style:
                                                          textbarlowBoldGreen(),
                                                    ),
                                                    SizedBox(width: 3),
                                                    cartItem['cart'][i]
                                                            ['isDealAvailable']
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0),
                                                            child: Text(
                                                              '$currency${((cartItem['cart'][i]['price']) * (cartItem['cart'][i]['quantity'])).toDouble().toStringAsFixed(2)}',
                                                              style:
                                                                  barlowregularlackstrike(),
                                                            ),
                                                          )
                                                        : Container(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Text(
                                                        " / " +
                                                            cartItem['cart'][i]
                                                                    ['unit']
                                                                .toString(),
                                                        style:
                                                            barlowregularlack(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                cartItem['cart'][i][
                                                            'isDealAvailable'] ==
                                                        true
                                                    ? Text(
                                                        MyLocalizations.of(
                                                                    context)
                                                                .deal +
                                                            " " +
                                                            (cartItem['cart'][i]
                                                                    [
                                                                    'delaPercent'])
                                                                .toString() +
                                                            "% " +
                                                            MyLocalizations.of(
                                                                    context)
                                                                .off,
                                                        style:
                                                            barlowregularlack(),
                                                        // textBarlowRegularBlack(),
                                                      )
                                                    : Text("")
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              height: 110,
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
                                                      if (cartItem['cart'][i][
                                                                  'isQuantityUpdating'] ==
                                                              null ||
                                                          cartItem['cart'][i][
                                                                  'isQuantityUpdating'] ==
                                                              false) {
                                                        _incrementCount(i);
                                                      }
                                                    },
                                                    child: cartItem['cart'][i][
                                                                    'isQuantityUpdating'] ==
                                                                true &&
                                                            quantityUpdateType ==
                                                                '+'
                                                        ? GFLoader(
                                                            type: GFLoaderType
                                                                .ios,
                                                            size: 34,
                                                          )
                                                        : SvgPicture.asset(
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
                                                      if (cartItem['cart'][i][
                                                                  'isQuantityUpdating'] ==
                                                              null ||
                                                          cartItem['cart'][i][
                                                                  'isQuantityUpdating'] ==
                                                              false) {
                                                        _decrementCount(i);
                                                      }
                                                    },
                                                    child: cartItem['cart'][i][
                                                                    'isQuantityUpdating'] ==
                                                                true &&
                                                            quantityUpdateType ==
                                                                '-'
                                                        ? GFLoader(
                                                            type: GFLoaderType
                                                                .ios,
                                                            size: 34,
                                                          )
                                                        : SvgPicture.asset(
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
                  height: 165,
                )
              : isLoadingCart
                  ? SquareLoader()
                  : cartItem == null
                      ? Container(
                          height: 175.0,
                        )
                      : Container(
                          height: bottomBarHeight,
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
                                      '$currency${cartItem['subTotal'].toDouble().toStringAsFixed(2)}',
                                      style: textbarlowBoldsmBlack(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              cartItem['deliveryCharges'] == 0
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          new Text(
                                            MyLocalizations.of(context)
                                                .deliveryCharges,
                                            style: textBarlowRegularBlack(),
                                          ),
                                          new Text(
                                            '$currency${cartItem['deliveryCharges'].toDouble().toStringAsFixed(2)}',
                                            style: textbarlowBoldsmBlack(),
                                          ),
                                        ],
                                      ),
                                    ),
                              cartItem['deliveryCharges'] == 0
                                  ? Container()
                                  : SizedBox(height: 6),
                              cartItem['tax'] == 0
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            '$currency${cartItem['tax'].toDouble().toStringAsFixed(2)}',
                                            style: textbarlowBoldsmBlack(),
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(height: 6),
                              cartItem['couponInfo'] == null
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          new Text(
                                            MyLocalizations.of(context)
                                                    .couponApplied +
                                                " (" +
                                                "${MyLocalizations.of(context).discount}"
                                                    ")",
                                            style: textBarlowRegularBlack(),
                                          ),
                                          new Text(
                                            '$currency${cartItem['couponInfo']['couponDiscountAmount'].toDouble().toStringAsFixed(2)}',
                                            style: textbarlowBoldsmBlack(),
                                          ),
                                        ],
                                      ),
                                    ),
                              cartItem['couponInfo'] == null
                                  ? Container()
                                  : SizedBox(height: 6),
                              SizedBox(height: 10),
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
                                            '$currency${cartItem['grandTotal'].toDouble().toStringAsFixed(2)}',
                                            style: textbarlowBoldWhite(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          var result = Navigator.push(
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
                                          result.then((value) {
                                            getCartItems();
                                          });
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
