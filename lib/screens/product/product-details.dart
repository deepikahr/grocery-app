import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/model/addToCart.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/fav-service.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class Variants {
  const Variants(this.id, this.price, this.unit, this.productstock);
  final String id, unit;
  final int price, productstock;
}

class ProductDetails extends StatefulWidget {
  final int currentIndex;
  final List favProductList;
  final Map<String, Map<String, String>> localizedValues;
  final String locale, productID;
  ProductDetails(
      {Key key,
      this.productID,
      this.currentIndex,
      this.localizedValues,
      this.favProductList,
      this.locale})
      : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController tabController;
  var dropdownValue, variants;
  Map<String, dynamic> productDetail;
  String variantUnit, variantId, favId, currency;
  List<Variants> variantList;
  List favProductList;
  String currentCardId;

  int value;
  int groupValue = 0;
  bool sizeSelect = false,
      getTokenValue = false,
      isFavProduct = false,
      isFavListLoading = false,
      addProductTocart = false,
      isGetProductRating = false,
      isProductDetails = false,
      isFavProductLoading = false,
      isProductAlredayInCart = false;
  int quantity = 1, variantPrice, variantStock;
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
    getTokenValueMethod();

    _checkFavourite();

    super.initState();
  }

  getTokenValueMethod() async {
    if (mounted) {
      setState(() {
        isProductDetails = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await Common.getToken().then((onValue) {
      try {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              getTokenValue = true;
              getProductDetailsLog();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              getTokenValue = false;
              getProductDetailsWithLog();
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            getTokenValue = false;
            getProductDetailsWithLog();
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getTokenValue = false;
          getProductDetailsWithLog();
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductRating() {
    ProductService.productRating(productDetail['_id']).then((value) {
      try {
        if (mounted) {
          setState(() {
            isGetProductRating = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isGetProductRating = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetProductRating = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductDetailsLog() {
    ProductService.productDetailsLogin(widget.productID).then((value) {
      try {
        if (mounted) {
          setState(() {
            productDetail = value['response_data'];
            if (productDetail['cartAddedQuantity'] != null) {
              quantity = productDetail['cartAddedQuantity'];
              isProductAlredayInCart = productDetail['cartAdded'];
              currentCardId = value['response_data']['cartId'];
            }
            isProductDetails = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isProductDetails = false;
            productDetail = null;
          });
        }
        sentryError.reportError(error, stackTrace);
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

  getProductDetailsWithLog() {
    ProductService.productDetailsWithoutLogin(widget.productID).then((value) {
      try {
        if (mounted) {
          setState(() {
            productDetail = value['response_data'];
            isProductDetails = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isProductDetails = false;
            productDetail = null;
          });
        }
        sentryError.reportError(error, stackTrace);
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

  void _checkFavourite() async {
    if (mounted) {
      setState(() {
        isFavListLoading = true;
        isFavProductLoading = true;
      });
    }
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          bool isProductFound = false;
          setState(() {
            favProductList = onValue['response_data'];
            if (favProductList.length > 0) {
              for (int i = 0; i < favProductList.length; i++) {
                if (favProductList[i]['product'] != null) {
                  if (favProductList[i]['product']['_id'] ==
                      productDetail['_id']) {
                    if (mounted) {
                      setState(() {
                        isProductFound = true;
                        isFavListLoading = false;
                        isFavProduct = true;
                        isFavProductLoading = false;
                        favId = favProductList[i]['_id'];
                      });
                    }
                  }
                }
              }
              if (mounted && !isProductFound) {
                setState(() {
                  isFavProduct = false;
                  isFavProductLoading = false;
                  isFavListLoading = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  isFavListLoading = false;
                  isFavProduct = false;
                  isFavProductLoading = false;
                });
              }
            }
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isFavListLoading = false;
            isFavProduct = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isFavListLoading = false;
          isFavProduct = false;
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
    if (isFavProduct) {
      Map<String, dynamic> body = {"product": id};
      await FavouriteService.addToFav(body).then((onValue) {
        try {
          showSnackbar(onValue['response_data']);
          _checkFavourite();
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else {
      await FavouriteService.deleteToFav(id).then((onValue) {
        try {
          showSnackbar(onValue['response_data']);
          _checkFavourite();
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    }
  }

  addToCart(data) async {
    if (mounted) {
      setState(() {
        addProductTocart = true;
      });
    }

    if ((variantStock == null
            ? productDetail['variant'][0]['productstock']
            : variantStock) >=
        quantity) {
      if (isProductAlredayInCart) {
        Map<String, dynamic> body = {
          'cartId': currentCardId,
          'productId': data['_id'].toString(),
        };
        await CartService.deleteDataFromCart(body).then((onValue) {
          addProductToCart(data);
        });
      } else {
        addProductToCart(data);
      }
    } else {
      if (mounted) {
        setState(() {
          addProductTocart = false;
        });
      }
      showSnackbar(MyLocalizations.of(context)
              .limitedquantityavailableyoucantaddmorethan +
          " ${variantStock == null ? productDetail['variant'][0]['productstock'] : variantStock} " +
          MyLocalizations.of(context).ofthisitem);
    }
  }

  addProductToCart(data) {
    Map<String, dynamic> buyNowProduct = {
      "category": data['category'],
      "subcategory": data['subcategory'],
      'productId': data['_id'].toString(),
      'quantity': quantity,
      "price": double.parse(variantPrice == null
          ? productDetail['variant'][0]['price'].toString()
          : variantPrice.toString()),
      "unit": variantUnit == null
          ? productDetail['variant'][0]['unit'].toString()
          : variantUnit.toString()
    };
    AddToCart.addToCartMethod(buyNowProduct).then((onValue) {
      try {
        if (mounted) {
          setState(() {
            addProductTocart = false;
            groupValue = 0;
          });
        }
        if (onValue['response_code'] == 200) {
          var result = Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => new Home(
                currentIndex: 2,
                locale: widget.locale,
                localizedValues: widget.localizedValues,
              ),
            ),
          );
          result.then((value) {
            getTokenValueMethod();
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            addProductTocart = false;
          });
        }
        sentryError.reportError(error, stackTrace);
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
                              width: MediaQuery.of(context).size.width,
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
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                    Constants.IMAGE_URL_PATH +
                                        "tr:dpr-auto,tr:w-1000" +
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Text(
                                        '${productDetail['title'][0].toUpperCase()}${productDetail['title'].substring(1)}',
                                        style: textBarlowSemiBoldBlack(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0.0, right: 5.0, left: 5.0),
                                      child: RatingBar(
                                        initialRating: productDetail[
                                                    'averageRating'] ==
                                                null
                                            ? 0
                                            : double.parse(
                                                productDetail['averageRating']
                                                    .toString()),
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
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                right: 0.0,
                                                top: 3.0,
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30,
                                                child: Text(
                                                  '${productDetail['description'][0].toUpperCase()}${productDetail['description'].substring(1)}',
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
                                                  '$currency${variantPrice == null ? productDetail['variant'][0]['price'] : variantPrice}',
                                                  style: textbarlowBoldGreen(),
                                                ),
                                                SizedBox(width: 3),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Text(
                                                    "10/kg",
                                                    style:
                                                        barlowregularlackstrike(),
                                                  ),
                                                )
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
                                        MyLocalizations.of(context).quantity +
                                            ':',
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
                                                                ['productstock']
                                                            : variantStock) >
                                                        quantity) {
                                                      _changeProductQuantity(
                                                          true);
                                                    } else {
                                                      showSnackbar(MyLocalizations
                                                                  .of(context)
                                                              .limitedquantityavailableyoucantaddmorethan +
                                                          " ${variantStock == null ? productDetail['variant'][0]['productstock'] : variantStock} " +
                                                          MyLocalizations.of(
                                                                  context)
                                                              .ofthisitem);
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
                                          return RadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            activeColor: primary,
                                            dense: true,
                                            value: i,
                                            groupValue: groupValue,
                                            onChanged: (int value) {
                                              if (mounted) {
                                                setState(() {
                                                  groupValue = value;
                                                  sizeSelect = !sizeSelect;
                                                  variantPrice =
                                                      productDetail['variant']
                                                          [value]['price'];
                                                  variantUnit =
                                                      productDetail['variant']
                                                          [value]['unit'];
                                                  variantId =
                                                      productDetail['variant']
                                                          [value]['_id'];
                                                  variantStock =
                                                      productDetail['variant']
                                                              [value]
                                                          ['productstock'];
                                                });
                                              }
                                            },
                                            selected: sizeSelect,
                                            secondary: Text(
                                              '${productDetail['variant'][i]['unit']}',
                                              style: hintSfMediumgreyersmall(),
                                            ),
                                            title: Text(
                                              '$currency${productDetail['variant'][i]['price']}',
                                              style: textbarlowBoldGreen(),
                                            ),
                                          );
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
                                              if (isFavProduct == true) {
                                                isFavProduct = false;
                                                addToFavApi(favId);
                                              } else {
                                                isFavProduct = true;
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
                                          : isFavProduct
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
                                        text: MyLocalizations.of(context).items,
                                        style: textBarlowRegularWhite()),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 1.0,
                              ),
                              new Text(
                                '$currency${variantPrice == null ? (productDetail['variant'][0]['price'] * quantity) : (variantPrice * quantity)}',
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
                          MyLocalizations.of(context).addToCart,
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
