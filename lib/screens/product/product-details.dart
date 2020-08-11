import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/model/addToCart.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/fav-service.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

SentryError sentryError = new SentryError();

class Variants {
  const Variants(this.id, this.price, this.unit, this.productstock);
  final String id, unit;
  final int price, productstock;
}

class ProductDetails extends StatefulWidget {
  final int currentIndex;

  final Map localizedValues;
  final String locale, productID;
  ProductDetails(
      {Key key,
      this.productID,
      this.currentIndex,
      this.localizedValues,
      this.locale})
      : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var productDetail;
  String variantUnit, variantId, currency, description;

  int groupValue = 0;
  bool sizeSelect = false,
      getTokenValue = false,
      addProductTocart = false,
      isProductDetails = false,
      isFavProductLoading = false,
      isProductAlredayInCart = false;
  var quantity = 1, variantPrice, variantStock;
  var rating;
  void _changeProductQuantity(bool increase) {
    if (increase) {
      if (mounted) {
        setState(() {
          quantity++;
        });
      }
    } else {
      if (quantity > 1) {
        if (mounted) {
          setState(() {
            quantity--;
          });
        }
      }
    }
  }

  @override
  void initState() {
    getProductDetailsLog();
    getTokenValueMethod();
    super.initState();
  }

  getTokenValueMethod() async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      if (mounted) {
        setState(() {
          if (onValue != null) {
            getTokenValue = true;
          } else {
            getTokenValue = false;
          }
        });
      }
    });
  }

  getProductDetailsLog() {
    if (mounted) {
      setState(() {
        isProductDetails = true;
      });
    }
    ProductService.productDetails(widget.productID).then((value) {
      if (mounted) {
        setState(() {
          productDetail = value['response_data'];
          if (productDetail['quantityToCart'] != null) {
            quantity = productDetail['quantityToCart'];
            isProductAlredayInCart = productDetail['isAddedToCart'];
          }
          isProductDetails = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isProductDetails = false;
          productDetail = null;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getToken(productDetail) async {
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            addToCart(productDetail);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isProductDetails: true,
                ),
              ),
            );
          });
        }
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  addToFavApi(id) async {
    setState(() {
      isFavProductLoading = true;
    });
    await FavouriteService.addToFav(id).then((onValue) {
      setState(() {
        productDetail['isFavourite'] = true;
        isFavProductLoading = false;
        showSnackbar(onValue['response_data']);
      });
    }).catchError((error) {
      setState(() {
        isFavProductLoading = false;
        productDetail['isFavourite'] = false;
      });
      sentryError.reportError(error, null);
    });
  }

  removeToFavApi(id) async {
    setState(() {
      isFavProductLoading = true;
    });

    await FavouriteService.deleteToFav(id).then((onValue) {
      setState(() {
        isFavProductLoading = false;
        showSnackbar(onValue['response_data']);
        productDetail['isFavourite'] = false;
      });
    }).catchError((error) {
      setState(() {
        productDetail['isFavourite'] = true;
        isFavProductLoading = false;
      });
      sentryError.reportError(error, null);
    });
  }

  addToCart(data) async {
    if ((variantStock == null
            ? productDetail['variant'][0]['productStock']
            : variantStock) >=
        quantity) {
      addProductToCart(data);
    } else {
      if (mounted) {
        setState(() {
          addProductTocart = false;
        });
      }
      showSnackbar(MyLocalizations.of(context)
              .getLocalizations("LIMITED_STOCK") +
          " ${variantStock == null ? productDetail['variant'][0]['productStock'] : variantStock} " +
          MyLocalizations.of(context).getLocalizations("OF_THIS_ITEM"));
    }
  }

  addProductToCart(data) {
    if (mounted) {
      setState(() {
        addProductTocart = true;
      });
    }
    Map<String, dynamic> buyNowProduct = {
      'productId': data['_id'].toString(),
      'quantity': quantity,
      "unit": variantUnit == null
          ? productDetail['variant'][0]['unit'].toString()
          : variantUnit.toString()
    };
    AddToCart.addAndUpdateProductMethod(buyNowProduct).then((onValue) {
      if (mounted) {
        setState(() {
          addProductTocart = false;
          groupValue = 0;
        });
      }
      if (onValue['message'] != null) {
        showSnackbar(onValue['message'] ?? "");
      }
      Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.of(context).pop(true);
      });
      if (onValue['response_data'] is Map) {
        Common.setCartData(onValue['response_data']);
      } else {
        Common.setCartData(null);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          addProductTocart = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  cartClear(responseData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(responseData['message'], style: textBarlowRegularrBlack()),
          actions: <Widget>[
            FlatButton(
              child:
                  Text(MyLocalizations.of(context).getLocalizations("CANCEL")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                  MyLocalizations.of(context).getLocalizations("CLEAR_CART")),
              onPressed: () {
                Navigator.pop(context);

                CartService.deleteAllDataFromCart().then((response) {
                  if (response['response_data'] is Map) {
                    Common.setCartData(response['response_data']);
                  } else {
                    Common.setCartData(null);
                  }
                });
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
      body: isProductDetails
          ? SquareLoader()
          : Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              height: 340,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10.0,
                                    offset: Offset(
                                      2.0,
                                      2.0,
                                    ),
                                  )
                                ],
                                image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new NetworkImage(
                                    productDetail['filePath'] == null
                                        ? productDetail['imageUrl']
                                        : Constants.imageUrlPath +
                                            "/tr:dpr-auto,tr:w-1000" +
                                            productDetail['filePath'],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 7,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          '${productDetail['title'][0].toUpperCase()}${productDetail['title'].substring(1)}',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: textBarlowSemiBoldBlack(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, right: 5.0, left: 5.0),
                                        child: RatingBar(
                                          initialRating: double.parse(
                                                  productDetail['averageRating']
                                                      .toStringAsFixed(1)) ??
                                              0.0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 15.0,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.red,
                                            size: 10.0,
                                          ),
                                          onRatingUpdate: null,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          productDetail['description'] == null
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 0.0,
                                                    top: 3.0,
                                                  ),
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            30,
                                                    child: Text(
                                                      '${productDetail['description']}',
                                                      style:
                                                          textbarlowRegularBlack(),
                                                    ),
                                                  )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                top: 5.0,
                                                right: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  productDetail[
                                                          'isDealAvailable']
                                                      ? "$currency${((variantPrice == null ? productDetail['variant'][0]['price'] : variantPrice) - ((variantPrice == null ? productDetail['variant'][0]['price'] : variantPrice) * (productDetail['dealPercent'] / 100))).toDouble().toStringAsFixed(2)}"
                                                      : '$currency${(variantPrice == null ? productDetail['variant'][0]['price'] : variantPrice).toDouble().toStringAsFixed(2)}',
                                                  style: textbarlowBoldGreen(),
                                                ),
                                                SizedBox(width: 3),
                                                productDetail['isDealAvailable']
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: Text(
                                                          "$currency${(variantPrice == null ? productDetail['variant'][0]['price'] : variantPrice).toDouble().toStringAsFixed(2)}",
                                                          style:
                                                              barlowregularlackstrike(),
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        MyLocalizations.of(context)
                                            .getLocalizations("QUANTITY", true),
                                        style: textBarlowMediumBlack(),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        height: 34,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  _changeProductQuantity(false);
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: primary,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, right: 20),
                                              child: Container(
                                                  child: Text(
                                                      quantity.toString())),
                                            ),
                                            Text(''),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0),
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    if ((variantStock == null
                                                            ? productDetail[
                                                                    'variant'][0]
                                                                ['productStock']
                                                            : variantStock) >
                                                        quantity) {
                                                      _changeProductQuantity(
                                                          true);
                                                    } else {
                                                      showSnackbar(MyLocalizations
                                                                  .of(context)
                                                              .getLocalizations(
                                                                  "LIMITED_STOCK") +
                                                          " ${variantStock == null ? productDetail['variant'][0]['productStock'] : variantStock} " +
                                                          MyLocalizations.of(
                                                                  context)
                                                              .getLocalizations(
                                                                  "OF_THIS_ITEM"));
                                                    }
                                                  },
                                                  child: Icon(Icons.add),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                productDetail['variant'].length > 1
                                    ? ListView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: productDetail['variant']
                                                    .length ==
                                                null
                                            ? 0
                                            : productDetail['variant'].length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return productDetail['variant'][i]
                                                      ['productStock'] >
                                                  0
                                              ? RadioListTile(
                                                  value: i,
                                                  groupValue: groupValue,
                                                  selected: sizeSelect,
                                                  activeColor: primary,
                                                  onChanged: (int value) {
                                                    if (mounted) {
                                                      setState(() {
                                                        groupValue = value;
                                                        sizeSelect =
                                                            !sizeSelect;
                                                        variantPrice =
                                                            productDetail[
                                                                    'variant'][
                                                                value]['price'];
                                                        variantUnit =
                                                            productDetail[
                                                                    'variant']
                                                                [value]['unit'];
                                                        variantId =
                                                            productDetail[
                                                                    'variant']
                                                                [value]['_id'];
                                                        variantStock =
                                                            productDetail[
                                                                        'variant']
                                                                    [value][
                                                                'productStock'];
                                                      });
                                                    }
                                                  },
                                                  secondary: Text(
                                                    '${productDetail['variant'][i]['unit']}',
                                                    style:
                                                        textbarlowBoldGreen(),
                                                  ),
                                                  title: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        productDetail[
                                                                'isDealAvailable']
                                                            ? "$currency${(productDetail['variant'][i]['price'] - (productDetail['variant'][i]['price'] * (productDetail['dealPercent'] / 100))).toDouble().toStringAsFixed(2)}"
                                                            : '$currency${productDetail['variant'][i]['price'].toDouble().toStringAsFixed(2)}',
                                                        style:
                                                            textbarlowBoldGreen(),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: productDetail[
                                                                'isDealAvailable']
                                                            ? Text(
                                                                '$currency${productDetail['variant'][i]['price'].toDouble().toStringAsFixed(2)}',
                                                                style:
                                                                    barlowregularlackstrike(),
                                                              )
                                                            : Container(),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container();
                                        })
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: 310.0,
                          left: 280.0,
                          child: !getTokenValue
                              ? Container()
                              : Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black.withOpacity(0.29),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: GFIconButton(
                                    onPressed: null,
                                    icon: GestureDetector(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            if (!isFavProductLoading) {
                                              if (productDetail[
                                                      'isFavourite'] ==
                                                  true) {
                                                removeToFavApi(
                                                    productDetail['_id']);
                                              } else {
                                                addToFavApi(
                                                    productDetail['_id']);
                                              }
                                            }
                                          });
                                        }
                                      },
                                      child: isFavProductLoading
                                          ? GFLoader(
                                              type: GFLoaderType.ios, size: 27)
                                          : productDetail['isFavourite'] == true
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
                        Positioned(
                          top: 45,
                          left: 20,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.black26,
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: isProductDetails
          ? Container(height: 65.0)
          : Container(
              height: 65.0,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 20.0, end: 20.0, bottom: 5.0),
                child: RawMaterialButton(
                  padding: EdgeInsetsDirectional.only(start: .0, end: 15.0),
                  fillColor: primary,
                  constraints: const BoxConstraints(minHeight: 44.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Container(
                          color: Colors.black,
                          margin: EdgeInsets.only(right: 0),
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 2.0,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '(${quantity.toString()})  ',
                                      style: textBarlowRegularWhite(),
                                    ),
                                    TextSpan(
                                        text: MyLocalizations.of(context)
                                            .getLocalizations("ITEMS"),
                                        style: textBarlowRegularWhite()),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 1.0,
                              ),
                              new Text(
                                productDetail['isDealAvailable']
                                    ? "$currency${((((variantPrice == null ? productDetail['variant'][0]['price'] : variantPrice) - ((variantPrice == null ? productDetail['variant'][0]['price'] : variantPrice) * (productDetail['dealPercent'] / 100)))) * quantity).toDouble().toStringAsFixed(2)}"
                                    : '$currency${((variantPrice == null ? productDetail['variant'][0]['price'] : variantPrice) * quantity).toDouble().toStringAsFixed(2)}',
                                style: textbarlowBoldWhite(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      addProductTocart
                          ? GFLoader(
                              type: GFLoaderType.ios,
                            )
                          : Text(""),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: new Text(
                          MyLocalizations.of(context)
                              .getLocalizations("ADD_TO_CART"),
                          style: textBarlowRegularBlack(),
                        ),
                      ),
                      Icon(Icons.shopping_cart, color: Colors.black)
                    ],
                  ),
                  onPressed: () {
                    if (getTokenValue == true) {
                      addToCart(productDetail);
                    } else {
                      getToken(productDetail);
                    }
                  },
                ),
              ),
            ),
    );
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
