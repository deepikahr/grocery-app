import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/cart-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class Variants {
  const Variants(
    this.id,
    this.price,
    this.unit,
  );
  final String id, unit;
  final int price;
}

class ProductDetails extends StatefulWidget {
  final int currentIndex;
  final List favProductList;
  final Map<String, Map<String, String>> localizedValues;

  final Map<String, dynamic> productDetail;

  ProductDetails(
      {Key key,
      this.productDetail,
      this.currentIndex,
      this.localizedValues,
      this.favProductList})
      : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController tabController;
  var dropdownValue, variants;

  String variantUnit, variantId, favId, currency;
  List<Variants> variantList;
  List favProductList;

  bool getTokenValue = false,
      isFavProduct = false,
      isFavListLoading = false,
      addProductTocart = false,
      isGetProductRating = false;
  int quantity = 1, variantPrice;
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
    print(widget.favProductList);
    getToken();
    if (widget.favProductList != null) {
      _checkFavourite();
    }
    super.initState();

    variantList = [];
    for (int i = 0; i < widget.productDetail['variant'].length; i++) {
      variantList.add(
        Variants(
          widget.productDetail['variant'][i]['_id'].toString(),
          widget.productDetail['variant'][i]['price'],
          widget.productDetail['variant'][i]['unit'],
        ),
      );
    }
  }

  getProductRating() {
    if (mounted) {
      setState(() {
        isGetProductRating = true;
      });
    }
    ProductService.productRating(widget.productDetail['_id']).then((value) {
      print(value);
      if (mounted) {
        setState(() {
          isGetProductRating = false;
        });
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  void _checkFavourite() async {
    if (mounted) {
      setState(() {
        isFavListLoading = true;
      });
    }
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            favProductList = onValue['response_data'];
            if (favProductList.length > 0) {
              for (int i = 0; i < favProductList.length; i++) {
                if (favProductList[i]['product'] != null) {
                  if (favProductList[i]['product']['_id'] ==
                      widget.productDetail['_id']) {
                    if (mounted) {
                      setState(() {
                        isFavListLoading = false;
                        isFavProduct = true;
                        favId = favProductList[i]['_id'];
                        print(favId);
                      });
                    }
                  }
                }
              }
            } else {
              if (mounted) {
                setState(() {
                  isFavListLoading = false;
                  isFavProduct = false;
                });
              }
            }
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            getTokenValue = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            getTokenValue = false;
          });
        }
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  addToFavApi(id) async {
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
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    }
  }

  addToCart(data, buy) async {
    if (getTokenValue) {
      if (mounted) {
        setState(() {
          addProductTocart = true;
        });
      }
      Map<String, dynamic> buyNowProduct = {
        'productId': data['_id'].toString(),
        'quantity': quantity,
        "price": double.parse(variantPrice == null
            ? widget.productDetail['variant'][0]['price'].toString()
            : variantPrice.toString()),
        "unit": variantUnit == null
            ? widget.productDetail['variant'][0]['unit'].toString()
            : variantUnit.toString()
      };
      await CartService.addProductToCart(buyNowProduct).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              addProductTocart = false;
            });
          }
          if (onValue['response_code'] == 200) {
            showSnackbar("Product ADD To Card Successfully");
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else {
      showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text('First Login!!'),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
              ),
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
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
                        height: 340,
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10.0, // soften the shadow
                              offset: Offset(
                                2.0, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                              widget.productDetail['imageUrl'],
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
                                padding: const EdgeInsets.only(
                                    top: 0.0, right: 20.0),
                                child: RatingBar(
                                  initialRating:
                                      widget.productDetail['averageRating'] ==
                                              null
                                          ? 3
                                          : double.parse(widget
                                              .productDetail['averageRating']
                                              .toString()),
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
                                  onRatingUpdate: null,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          '$currency ${variantPrice == null ? widget.productDetail['variant'][0]['price'] : variantPrice}',
                                          style: TextStyle(
                                              color: const Color(0xFF00BFA5),
                                              fontSize: 17.0),
                                        ),
                                      )
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
                          width: 130.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: primary),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                DropdownButton<Variants>(
                                  hint: Text(
                                      '${widget.productDetail['variant'][0]["unit"].toString()}'),
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
                                  onChanged: (Variants newValue) {
                                    if (mounted) {
                                      setState(() {
                                        dropdownValue = newValue;
                                        variantPrice = newValue.price;
                                        variantUnit = newValue.unit;
                                        variantId = newValue.id;
                                      });
                                    }
                                  },
                                  items: variantList.map((Variants user) {
                                    return DropdownMenuItem<Variants>(
                                      value: user,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            user.unit,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
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
                    child: !getTokenValue
                        ? Container()
                        : Container(
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
                                  if (mounted) {
                                    setState(() {
                                      if (isFavProduct == true) {
                                        isFavProduct = false;
                                        addToFavApi(favId);
                                      } else {
                                        isFavProduct = true;
                                        addToFavApi(
                                            widget.productDetail['_id']);
                                      }
                                    });
                                  }
                                },
                                child: isFavProduct
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
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 110.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20.0,
                end: 20.0,
                bottom: 10.0,
              ),
              child: RawMaterialButton(
                onPressed: null,
                padding: EdgeInsetsDirectional.only(start: 15.0, end: 15.0),
                fillColor: primaryLight,
                constraints: const BoxConstraints(minHeight: 44.0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _changeProductQuantity(false);
                      },
                      child: Container(
                        child: Image(
                          image: AssetImage('lib/assets/icons/minus.png'),
                          width: 26.0,
                          color: primary,
                        ),
                      ),
                    ),
                    new Container(
                      alignment: AlignmentDirectional.center,
                      width: 26.0,
                      height: 26.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                      ),
                      child: new Text(
                        quantity.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _changeProductQuantity(true);
                      },
                      child: Container(
                          child: Image(
                        image: AssetImage('lib/assets/icons/addbtn.png'),
                        width: 26.0,
                        color: primary,
                      )),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 50.0,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 20.0, end: 20.0, bottom: 1.0),
                child: RawMaterialButton(
                  padding: EdgeInsetsDirectional.only(start: 15.0, end: 15.0),
                  fillColor: primary,
                  constraints: const BoxConstraints(minHeight: 44.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            new Text(
                              '${variantUnit == null ? widget.productDetail['variant'][0]['unit'] : variantUnit}',
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            new Text(
                              '$currency ${variantPrice == null ? (widget.productDetail['variant'][0]['price'] * quantity) : (variantPrice * quantity)}',
                            ),
                          ],
                        ),
                      ),
                      addProductTocart
                          ? Image.asset(
                              'lib/assets/images/spinner.gif',
                              width: 15.0,
                              height: 15.0,
                              color: Colors.black,
                            )
                          : Text(""),
                      new Text(
                        "ADD TO CART",
                      ),
                    ],
                  ),
                  onPressed: () {
                    addToCart(widget.productDetail, 'cart');
                  },
                ),
              ),
            ),
          ],
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
