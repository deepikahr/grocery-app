import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/tab/mycart.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/cart-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/fav-service.dart';
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

  int value;
  int groupValue = 0;
  bool sizeSelect = false;

  bool getTokenValue = false,
      isFavProduct = false,
      isFavListLoading = false,
      addProductTocart = false,
      isGetProductRating = false;
  int quantity = 1, variantPrice, variantProductstock;
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
          widget.productDetail['variant'][i]['productstock'] == null
              ? 1
              : widget.productDetail['variant'][i]['productstock'],
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
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new MyCart(),
              ),
            );
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
                  new Text('First Login!!', style: hintSfboldBig(),),
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

  sizeSelectOnChanged(value){
    return setState(() {
      groupValue = value;
      print(groupValue);
      // if (sizeSelect == true) {
      variantPrice = variantList[value].price;
      variantUnit = variantList[value].unit;
      variantId = variantList[value].id;
      // }
    });
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
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        height: 340,
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
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
                                  style: textBarlowSemiBoldBlack(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, right: 20.0),
                                child: RatingBar(
                                  initialRating:
                                      widget.productDetail['averageRating'] ==
                                              null
                                          ? 0
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
                            // margin: EdgeInsets.only(left:20,right:20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            right: 0.0, top: 3.0),
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              30,
                                          child: Text(
                                            '${widget.productDetail['description'][0].toUpperCase()}${widget.productDetail['description'].substring(1)}',
                                            style: textbarlowRegularBlack(),
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 5.0),
                                      child: Text(
                                        '$currency${variantPrice == null ? widget.productDetail['variant'][0]['price'] : variantPrice}',
                                        style: textbarlowBoldGreen(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Quantity:',
                                  style: textBarlowMediumBlack(),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  height: 34,
                                  width: 150,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
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
                                      Text(''),
                                      Text(''),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 40.0),
                                        child: Container(
                                            child: Text(quantity.toString())),
                                      ),
                                      Text(''),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 37.0),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: InkWell(
                                            onTap: () {
                                              _changeProductQuantity(true);
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
                          variantList.length > 1 ? ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: variantList.length == null
                                  ? 0
                                  : variantList.length,
                              itemBuilder: (BuildContext context, int i) {
                                print('v $variantList');
                                return
                                RadioListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  activeColor: primary,
                                  dense: true,
                                  value: i,
                                  groupValue: groupValue,
                                  onChanged: (int value) {
                                    sizeSelectOnChanged(value);
                                  },
                                  selected: sizeSelect,
                                  secondary: Text('${variantList[i].unit}', style: hintSfMediumgreyersmall() ,),
                                  title: Text(
                                      '$currency${variantList[i].price.toString()}', style: textbarlowBoldGreen(),),
                                );
                              }) : Container(),
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
                  Positioned(
                    top: 45,
                    left: 20,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: Colors.grey[300],
          //         borderRadius: BorderRadius.circular(30.0)),
          //     height: 47,
          //     width: 150,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         Container(
          //           width: 40,
          //           height: 40,
          //           decoration: BoxDecoration(
          //               color: Colors.black,
          //               borderRadius: BorderRadius.circular(20.0)),
          //           child: InkWell(
          //             onTap: () {
          //               _changeProductQuantity(false);
          //             },
          //             child: Icon(
          //               Icons.remove,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //         Text(''),
          //         Padding(
          //           padding: const EdgeInsets.only(left: 14.0),
          //           child: Container(child: Text(quantity.toString())),
          //         ),
          //         Text(''),
          //         Padding(
          //           padding: const EdgeInsets.only(left: 17.0),
          //           child: Container(
          //             width: 40,
          //             height: 40,
          //             decoration: BoxDecoration(
          //                 color: primary,
          //                 borderRadius: BorderRadius.circular(20.0)),
          //             child: InkWell(
          //               onTap: () {
          //                 if ((variantProductstock == null
          //                         ? widget.productDetail['variant'][0]
          //                                     ['productstock'] ==
          //                                 null
          //                             ? 1
          //                             : widget.productDetail['variant'][0]
          //                                 ['productstock']
          //                         : variantProductstock) ==
          //                     quantity) {
          //                   showSnackbar("Product only few stock");
          //                 } else {
          //                   _changeProductQuantity(true);
          //                 }
          //               },
          //               child: Icon(Icons.add),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Container(
        height: 50.0,
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
                  padding: const EdgeInsets.only(right: .0),
                  child: Container(
                    color: Colors.black,
                    margin: EdgeInsets.only(right: 50),
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
                                text: '${quantity.toString()}',
                                style: textBarlowRegularWhite(),
                              ),
                              TextSpan(
                                  text: ' Item',
                                  style: textBarlowRegularWhite()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 1.0,
                        ),
                        new Text(
                          '$currency${variantPrice == null ? (widget.productDetail['variant'][0]['price'] * quantity) : (variantPrice * quantity)}',
                          style: textbarlowBoldWhite(),
                        ),
                      ],
                    ),
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
//                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: new Text(
                    "ADD TO CART",
                    style: textBarlowRegularBlack(),
                  ),
                ),
                Icon(Icons.shopping_cart, color: Colors.black)
              ],
            ),
            onPressed: () {
              addToCart(widget.productDetail, 'cart');
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

//Container(
//width: 130.0,
//decoration: BoxDecoration(
//borderRadius: BorderRadius.circular(50.0)),
//child: Container(
//decoration: BoxDecoration(
//color: Colors.white,
//borderRadius: BorderRadius.circular(20),
//border: Border.all(color: primary),
//),
//child: Row(
//mainAxisAlignment: MainAxisAlignment.center,
//children: <Widget>[
//DropdownButton<Variants>(
//hint: Text(
//'${widget.productDetail['variant'][0]["unit"].toString()}',
//style: textBarlowRegularBlack(),
//),
//value: dropdownValue,
//icon: Padding(
//padding: const EdgeInsets.only(left: 10.0),
//child: Icon(Icons.arrow_drop_down),
//),
//iconSize: 24,
//itemHeight: 49.0,
//elevation: 16,
//style: TextStyle(
//color: Colors.black,
//),
//underline: Container(
//color: Colors.white,
//),
//onChanged: (Variants newValue) {
//if (mounted) {
//setState(() {
//dropdownValue = newValue;
//variantPrice = newValue.price;
//variantUnit = newValue.unit;
//variantId = newValue.id;
//variantProductstock =
//newValue.productstock;
//});
//}
//},
//items: variantList.map((Variants user) {
//return DropdownMenuItem<Variants>(
//value: user,
//child: Row(
//children: <Widget>[
//Text(
//user.unit,
//style: textBarlowRegularBlack(),
//),
//],
//),
//);
//}).toList(),
//),
//],
//),
//),
//),
