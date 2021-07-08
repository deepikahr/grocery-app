import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:readymadeGroceryApp/model/addToCart.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/screens/checkout/checkout.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class MyCart extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;

  MyCart({Key? key, this.locale, this.localizedValues}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoadingCart = false,
      isGetTokenLoading = false,
      isUpdating = false,
      isMinAmountCheckLoading = false,
      isCheckProductAvailableOrNot = false;
  String? token, currency;
  String quantityUpdateType = '+';
  Map? cartItem;
  double bottomBarHeight = 150;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var minAmout;

  @override
  void initState() {
    getToken();
    checkMinOrderAmount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkMinOrderAmount() async {
    if (mounted) {
      setState(() {
        isMinAmountCheckLoading = true;
      });
    }
    await LoginService.getLocationformation().then((onValue) {
      if (mounted) {
        setState(() {
          minAmout = onValue['response_data'];
          isMinAmountCheckLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          minAmout = null;
          isMinAmountCheckLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getToken() async {
    if (mounted) {
      setState(() {
        isGetTokenLoading = true;
      });
    }
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
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
        cartItem!['products'][i]['quantity']++;
        updateCart(i);
      });
  }

  void _decrementCount(i) {
    quantityUpdateType = '-';
    if (cartItem!['products'][i]['quantity'] > 1) {
      if (mounted) {
        setState(() {
          cartItem!['products'][i]['quantity']--;
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
      'unit': cartItem!['products'][i]['unit'],
      'productId': cartItem!['products'][i]['productId'],
      'quantity': cartItem!['products'][i]['quantity']
    };
    if (mounted) {
      setState(() {
        isUpdating = true;
        cartItem!['products'][i]['isQuantityUpdating'] = true;
      });
    }
    await AddToCart.addAndUpdateProductMethod(body).then((onValue) {
      if (mounted) {
        setState(() {
          isUpdating = false;
          cartItem = onValue['response_data'];
          cartItem!['products'][i]['quantity'] =
              cartItem!['products'][i]['quantity'];
          cartItem!['products'][i]['isQuantityUpdating'] = false;
        });
      }
      if (onValue['message'] != null) {
        showSnackbar(onValue['message'] ?? "");
      }

      if (onValue['response_data'] is Map) {
        Common.setCartData(onValue['response_data']);
      } else {
        Common.setCartData(null);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isUpdating = false;
          cartItem!['products'][i]['quantity']--;
          cartItem!['products'][i]['quantity'] =
              cartItem!['products'][i]['quantity'];
          cartItem!['products'][i]['isQuantityUpdating'] = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }

  // get to cart
  getCartItems() async {
    if (mounted) {
      setState(() {
        isLoadingCart = true;
      });
    }
    await CartService.getProductToCart().then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          isLoadingCart = false;
        });
      }
      if (onValue['response_data'] is Map &&
          onValue['response_data']['products'] != [] &&
          mounted) {
        Common.setCartData(onValue['response_data']);
        setState(() {
          cartItem = onValue['response_data'];
          if (cartItem!['grandTotal'] != null) {
            bottomBarHeight = 150;
            if (cartItem!['deliveryCharges'] == 0 &&
                cartItem!['deliveryAddress'] != null) {
              bottomBarHeight = bottomBarHeight + 20;
            }
            if (cartItem!['tax'] != 0) {
              bottomBarHeight = bottomBarHeight + 20;
            }
            if (cartItem!['couponInfo'] != null) {
              bottomBarHeight = bottomBarHeight + 20;
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            Common.setCartData(null);
            cartItem = null;
            isLoadingCart = false;
          });
        }
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

  //delete from cart
  deleteCart(i) async {
    await CartService.deleteDataFromCart(cartItem!['products'][i]['productId'])
        .then((onValue) {
      if (onValue['response_data'] is Map &&
          onValue['response_data']['products'].length == 0 &&
          mounted) {
        setState(() {
          cartItem = null;
          deleteAllCart();
          Common.setCartData(null);
        });
      } else {
        setState(() {
          getCartItems();
        });
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

  deleteAllCart() async {
    await CartService.deleteAllDataFromCart().then((onValue) {
      Common.setCartData(null);
      if (mounted) {
        setState(() {
          cartItem = null;
          getCartItems();
        });
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  checkMinOrderAmountCondition() async {
    if (minAmout['minimumOrderAmountToPlaceOrder'] == null) {
      minAmout['minimumOrderAmountToPlaceOrder'] = 0.0;
    }
    if (cartItem!['subTotal'] >= minAmout['minimumOrderAmountToPlaceOrder']) {
      checkProductAvailableOrNot();
    } else {
      showError(MyLocalizations.of(context)!
              .getLocalizations("MIN_AMOUNT_MEG") +
          "($currency${minAmout['minimumOrderAmountToPlaceOrder'].toString()})");
    }
  }

  checkProductAvailableOrNot() async {
    if (mounted) {
      setState(() {
        isCheckProductAvailableOrNot = true;
      });
    }
    CartService.checkCartVerifyOrNot().then((response) {
      if (mounted) {
        setState(() {
          isCheckProductAvailableOrNot = false;
        });
      }
      var result = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Checkout(
            locale: widget.locale,
            localizedValues: widget.localizedValues,
            id: cartItem!['_id'].toString(),
          ),
        ),
      );
      result.then((value) {
        getCartItems();
      });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isCheckProductAvailableOrNot = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  showError(responseData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            responseData,
          ),
          actions: <Widget>[
            GFButton(
                color: Colors.transparent,
              child: Text(MyLocalizations.of(context)!.getLocalizations("OK")),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: isGetTokenLoading || isMinAmountCheckLoading
          ? null
          : token == null
              ? null
              : appBarWhite(context, "MY_CART", false, false, Container())
                  as PreferredSizeWidget?,
      body: isGetTokenLoading || isMinAmountCheckLoading
          ? SquareLoader()
          : token == null
              ? Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isCart: true,
                )
              : cartItem == null
                  ? noDataImage()
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
                                          ? textMediumSmall(
                                              '0 ' +
                                                  MyLocalizations.of(context)!
                                                      .getLocalizations("ITEM"),
                                              context)
                                          : textMediumSmall(
                                              '(${cartItem!['products'].length}) ' +
                                                  MyLocalizations.of(context)!
                                                      .getLocalizations("ITEM"),
                                              context),
                                      InkWell(
                                        onTap: () {
                                          deleteAllCart();
                                        },
                                        child: textMediumSmall(
                                            MyLocalizations.of(context)!
                                                .getLocalizations("CLEAR_CART"),
                                            context),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cartItem == null
                                      ? 0
                                      : cartItem!['products'].length,
                                  itemBuilder: (BuildContext context, int i) =>
                                      Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: cartCardBg(context)),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.tight,
                                          child: (cartItem!['products'][i]
                                                          ['productImages'] !=
                                                      null &&
                                                  cartItem!['products'][i]
                                                              ['productImages']
                                                          .length >
                                                      0)
                                              ? CachedNetworkImage(
                                                  imageUrl: cartItem!['products']
                                                                      [i]
                                                                  ['productImages']
                                                              [0]['filePath'] ==
                                                          null
                                                      ? cartItem!['products'][i]
                                                              ['productImages']
                                                          [0]['imageUrl']
                                                      : Constants
                                                              .imageUrlPath! +
                                                          "/tr:dpr-auto,tr:w-500" +
                                                          cartItem!['products']
                                                                      [i]
                                                                  ['productImages']
                                                              [0]['filePath'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    height: 90,
                                                    width: 117,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: dark(context)
                                                              .withOpacity(
                                                                  0.10),
                                                          blurRadius: 5,
                                                        )
                                                      ],
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                          height: 90,
                                                          width: 117,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.10),
                                                                blurRadius: 5,
                                                              )
                                                            ],
                                                          ),
                                                          child: noDataImage()),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Container(
                                                          height: 90,
                                                          width: 117,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.10),
                                                                blurRadius: 5,
                                                              )
                                                            ],
                                                          ),
                                                          child: noDataImage()),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: cartItem![
                                                                  'products'][i]
                                                              ['filePath'] ==
                                                          null
                                                      ? cartItem!['products'][i]
                                                          ['imageUrl']
                                                      : Constants
                                                              .imageUrlPath! +
                                                          "/tr:dpr-auto,tr:w-500" +
                                                          cartItem!['products']
                                                              [i]['filePath'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    height: 90,
                                                    width: 117,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: dark(context)
                                                              .withOpacity(
                                                                  0.10),
                                                          blurRadius: 5,
                                                        )
                                                      ],
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                          height: 90,
                                                          width: 117,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.10),
                                                                blurRadius: 5,
                                                              )
                                                            ],
                                                          ),
                                                          child: noDataImage()),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Container(
                                                          height: 90,
                                                          width: 117,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.10),
                                                                blurRadius: 5,
                                                              )
                                                            ],
                                                          ),
                                                          child: noDataImage()),
                                                ),
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          flex: 6,
                                          fit: FlexFit.tight,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                cartItem!['products'][i]
                                                    ['productName'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: 'BarlowRegular',
                                                    color: blackText(context),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: <Widget>[
                                                  priceMrpText(
                                                      currency! +
                                                          (cartItem!['products']
                                                                          [i][
                                                                      'productTotal'] ??
                                                                  .0)
                                                              .toDouble()
                                                              .toStringAsFixed(
                                                                  2)
                                                              .toString(),
                                                      cartItem!['products'][i][
                                                              'isDealAvailable']
                                                          ? '$currency${((cartItem!['products'][i]['price']) * (cartItem!['products'][i]['quantity'])).toDouble().toStringAsFixed(2)}'
                                                          : (cartItem!['products']
                                                                          [i][
                                                                      'isOfferAvailable'] ??
                                                                  false)
                                                              ? '$currency${((cartItem!['products'][i]['price']) * (cartItem!['products'][i]['quantity'])).toDouble().toStringAsFixed(2)}'
                                                              : null,
                                                      context),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: textLightSmall(
                                                          " / " +
                                                              cartItem!['products']
                                                                          [i]
                                                                      ['unit']
                                                                  .toString(),
                                                          context)),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              cartItem!['products'][i]
                                                          ['isDealAvailable'] ==
                                                      true
                                                  ? textLightSmall(
                                                      MyLocalizations.of(context)!
                                                              .getLocalizations(
                                                                  "DEAL") +
                                                          " " +
                                                          (cartItem!['products'][i]['dealPercent'])
                                                              .toString() +
                                                          "% " +
                                                          MyLocalizations.of(context)!
                                                              .getLocalizations(
                                                                  "OFF"),
                                                      context)
                                                  : cartItem!['products'][i]['isOfferAvailable'] ==
                                                          true
                                                      ? textLightSmall(
                                                          MyLocalizations.of(context)!.getLocalizations("OFFER") +
                                                              " " +
                                                              (cartItem!['products'][i]['offerPercent'])
                                                                  .toString() +
                                                              "% " +
                                                              MyLocalizations.of(context)!
                                                                  .getLocalizations("OFF"),
                                                          context)
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
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: primarybg,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (cartItem!['products']
                                                                      [i][
                                                                  'isQuantityUpdating'] ==
                                                              null ||
                                                          cartItem!['products']
                                                                      [i][
                                                                  'isQuantityUpdating'] ==
                                                              false) {
                                                        _incrementCount(i);
                                                      }
                                                    },
                                                    child: cartItem!['products']
                                                                        [i][
                                                                    'isQuantityUpdating'] ==
                                                                true &&
                                                            quantityUpdateType ==
                                                                '+'
                                                        ? GFLoader(
                                                            type: GFLoaderType
                                                                .ios,
                                                            size: 35)
                                                        : Icon(
                                                            Icons.add,
                                                            color: Colors.black,
                                                          ),
                                                  ),
                                                ),
                                                cartItem!['products'][i]
                                                            ['quantity'] ==
                                                        null
                                                    ? Text('0')
                                                    : titleTwoLine(
                                                        cartItem!['products'][i]
                                                                ['quantity']
                                                            .toString(),
                                                        context),
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: cartItem!['products']
                                                                        [i][
                                                                    'isQuantityUpdating'] ==
                                                                true &&
                                                            quantityUpdateType ==
                                                                '-'
                                                        ? primarybg
                                                        : Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (cartItem!['products']
                                                                      [i][
                                                                  'isQuantityUpdating'] ==
                                                              null ||
                                                          cartItem!['products']
                                                                      [i][
                                                                  'isQuantityUpdating'] ==
                                                              false) {
                                                        _decrementCount(i);
                                                      }
                                                    },
                                                    child: cartItem!['products']
                                                                        [i][
                                                                    'isQuantityUpdating'] ==
                                                                true &&
                                                            quantityUpdateType ==
                                                                '-'
                                                        ? GFLoader(
                                                            type: GFLoaderType
                                                                .ios,
                                                            size: 35)
                                                        : Icon(Icons.remove,
                                                            color: primarybg),
                                                  ),
                                                ),
                                              ],
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
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
      bottomNavigationBar: isGetTokenLoading ||
              isMinAmountCheckLoading ||
              isLoadingCart
          ? SquareLoader()
          : token == null || cartItem == null
              ? Container(height: 1)
              : Container(
                  height: bottomBarHeight,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: buildPrice(
                              context,
                              null,
                              MyLocalizations.of(context)!
                                      .getLocalizations("SUB_TOTAL") +
                                  ' ( ${cartItem!['products'].length} ' +
                                  MyLocalizations.of(context)!
                                      .getLocalizations("ITEMS") +
                                  ')',
                              '$currency${cartItem!['subTotal'].toDouble().toStringAsFixed(2)}',
                              false)),
                      SizedBox(height: 4),
                      cartItem!['tax'] == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: buildPrice(
                                  context,
                                  Image.asset(
                                    'lib/assets/icons/sale.png',
                                    color: dark(context),
                                  ),
                                  cartItem!['taxInfo'] == null
                                      ? MyLocalizations.of(context)!
                                          .getLocalizations("TAX")
                                      : MyLocalizations.of(context)!
                                              .getLocalizations("TAX") +
                                          " (" +
                                          cartItem!['taxInfo']['taxName'] +
                                          " " +
                                          cartItem!['taxInfo']['amount']
                                              .toString() +
                                          "%)",
                                  '$currency${cartItem!['tax'].toDouble().toStringAsFixed(2)}',
                                  false)),
                      SizedBox(height: 6),
                      cartItem!['couponCode'] == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: buildPrice(
                                  context,
                                  null,
                                  MyLocalizations.of(context)!
                                          .getLocalizations("COUPON_APPLIED") +
                                      " (" +
                                      "${cartItem!['couponCode']}"
                                          ")",
                                  '-$currency${cartItem!['couponAmount'].toDouble().toStringAsFixed(2)}',
                                  false)),
                      cartItem!['couponCode'] == null
                          ? Container()
                          : SizedBox(height: 6),
                      cartItem!['deliveryCharges'] == 0 &&
                              cartItem!['deliveryAddress'] != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: buildPrice(
                                  context,
                                  null,
                                  MyLocalizations.of(context)!
                                      .getLocalizations("DELIVERY_CHARGES"),
                                  MyLocalizations.of(context)!
                                      .getLocalizations("FREE"),
                                  false))
                          : cartItem!['deliveryCharges'] == 0
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: buildPrice(
                                      context,
                                      null,
                                      MyLocalizations.of(context)!
                                          .getLocalizations("DELIVERY_CHARGES"),
                                      '$currency${cartItem!['deliveryCharges'].toDouble().toStringAsFixed(2)}',
                                      false)),
                      InkWell(
                        onTap: checkMinOrderAmountCondition,
                        child: checkoutButton(
                            context,
                            "TOTAL",
                            '$currency${cartItem!['grandTotal'].toDouble().toStringAsFixed(2)}',
                            "CHECKOUT",
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                            isCheckProductAvailableOrNot),
                      ),
                    ],
                  ),
                ),
    );
  }
}
