import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/types/gf_loader_type.dart';
import 'package:readymadeGroceryApp/model/addToCart.dart';
import 'package:readymadeGroceryApp/model/bottomSheet.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:flutter/cupertino.dart';

class SubCategoryProductCard extends StatefulWidget {
  final variantStock, price, currency;
  final Map productData;
  final List variantList;
  final String locale;
  final Map localizedValues;
  SubCategoryProductCard(
      {Key key,
      this.variantStock,
      this.price,
      this.currency,
      this.productData,
      this.variantList,
      this.locale,
      this.localizedValues})
      : super(key: key);
  @override
  _SubCategoryProductCardState createState() => _SubCategoryProductCardState();
}

class _SubCategoryProductCardState extends State<SubCategoryProductCard> {
  int quanity;
  bool cardAdded = false, isAddInProgress = false, isQuantityUpdating = false;
  var variantPrice, variantStock, variantUnit, dealPercentage;
  String cartId, quantityChangeType = '+';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.productData['isAddedToCart'] == true) {
      cardAdded = widget.productData['isAddedToCart'];
    } else {
      cardAdded = false;
    }
    if (widget.variantStock != null) {
      variantStock = widget.variantStock;
    }
    if (widget.productData['isDealAvailable'] != null &&
        widget.productData['isDealAvailable'] == true) {
      dealPercentage =
          double.parse(widget.productData['dealPercent'].toStringAsFixed(1));
    } else {
      dealPercentage = null;
    }

    quanity = widget.productData['quantityToCart'] ?? 0;

    super.initState();
  }

  void _changeProductQuantity(bool increase, id) {
    setState(() {
      isQuantityUpdating = true;
    });
    if (increase) {
      quanity++;
      updateCart(quanity, id);
    } else {
      if (quanity > 1) {
        quanity--;
        updateCart(quanity, id);
      } else {
        deleteCart(id);
      }
    }
  }

  updateCart(quanity, id) async {
    Map<String, dynamic> body = {
      'unit': variantUnit == null
          ? widget.productData['variant'][0]['unit']
          : variantUnit,
      'productId': id,
      'quantity': quanity
    };

    await AddToCart.addAndUpdateProductMethod(body).then((onValue) {
      if (onValue['response_code'] == 200 && onValue['response_data'] is Map) {
        Common.setCartData(onValue['response_data']);
      } else {
        Common.setCartData(null);
      }
      if (mounted) {
        setState(() {
          isQuantityUpdating = false;
        });
      }
    });
  }

  deleteCart(id) async {
    await CartService.deleteDataFromCart(id).then((onValue) {
      if (onValue['response_code'] == 200 && onValue['response_data'] is Map) {
        Common.setCartData(onValue['response_data']);
      } else {
        Common.setCartData(null);
      }
      if (mounted) {
        setState(() {
          cardAdded = false;
          isQuantityUpdating = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = CardTheme.of(context);
    final double _defaultElevation = 1;
    final Clip _defaultClipBehavior = Clip.none;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Material(
            type: MaterialType.card,
            color: Theme.of(context).cardColor,
            elevation: _defaultElevation ?? cardTheme.elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            borderOnForeground: true,
            clipBehavior: _defaultClipBehavior ?? cardTheme.clipBehavior,
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    widget.productData['filePath'] != null
                        ? Constants.imageUrlPath +
                            "tr:dpr-auto,tr:w-500" +
                            widget.productData['filePath']
                        : widget.productData['imageUrl'],
                    fit: BoxFit.cover,
                    height: 123,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.productData['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textbarlowRegularBlackb(),
                            ),
                          ),
                          widget.productData['averageRating'] == null ||
                                  widget.productData['averageRating'] == 0.0 ||
                                  widget.productData['averageRating'] == '0.0'
                              ? Container()
                              : Container(
                                  height: 19,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    color: Color(0xFF20C978),
                                  ),
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                          widget.productData['averageRating']
                                              .toStringAsFixed(1),
                                          style: textBarlowregwhite()),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                dealPercentage == null
                                    ? '${widget.currency}${(variantPrice == null ? widget.price : variantPrice).toDouble().toStringAsFixed(2)}'
                                    : '${widget.currency}${((variantPrice == null ? widget.price : variantPrice) - ((variantPrice == null ? widget.price : variantPrice) * (dealPercentage / 100))).toDouble().toStringAsFixed(2)}',
                                style: textbarlowBoldgreen(),
                              ),
                              SizedBox(width: 3),
                              dealPercentage == null
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 0),
                                      child: Text(
                                        '${widget.currency}${(variantPrice == null ? widget.price : variantPrice).toDouble().toStringAsFixed(2)}',
                                        style: barlowregularlackstrike(),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(width: 3),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              '${variantUnit == null ? widget.productData['variant'][0]['unit'] : variantUnit}',
                              style: barlowregularlack(),
                            ),
                          )
                        ],
                      ),
                      !cardAdded
                          ? InkWell(
                              onTap: () async {
                                if (widget.variantList.length > 1) {
                                  if (widget.productData != null &&
                                      widget.variantList != null) {
                                    var bottomSheet = showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return BottonSheetClassDryClean(
                                              locale: widget.locale,
                                              localizedValues:
                                                  widget.localizedValues,
                                              currency: widget.currency,
                                              productData: widget.productData,
                                              dealPercentage: dealPercentage,
                                              variantsList: widget.variantList,
                                              productQuantity: quanity == null
                                                  ? widget.productData[
                                                          'quantityToCart'] ??
                                                      0
                                                  : quanity);
                                        });
                                    bottomSheet.then((onValue) {
                                      for (int i = 0;
                                          i < onValue['products'].length;
                                          i++) {
                                        if (widget.productData["_id"] ==
                                            onValue['products'][i]
                                                ["productId"]) {
                                          if (mounted) {
                                            setState(() {
                                              quanity = onValue['products'][i]
                                                  ['quantity'];
                                              variantPrice = onValue['products']
                                                  [i]['price'];
                                              cartId = onValue['_id'];
                                              variantStock = onValue['products']
                                                  [i]['productStock'];
                                              variantUnit = onValue['products']
                                                  [i]['unit'];
                                              cardAdded = true;
                                            });
                                          }
                                        }
                                      }
                                    });
                                  }
                                } else {
                                  await Common.getToken().then((onValue) {
                                    if (onValue != null) {
                                      if (mounted) {
                                        setState(() {
                                          if (widget.variantList[0]
                                                  ['productStock'] >
                                              quanity) {
                                            if (!isAddInProgress) {
                                              Map<String, dynamic>
                                                  productAddBody = {
                                                'productId': widget
                                                    .productData['_id']
                                                    .toString(),
                                                'quantity': 1,
                                                "unit": widget.variantList[0]
                                                        ['unit']
                                                    .toString()
                                              };
                                              setState(() {
                                                isAddInProgress = true;
                                              });
                                              AddToCart
                                                      .addAndUpdateProductMethod(
                                                          productAddBody)
                                                  .then((onValue) {
                                                if (onValue['response_code'] ==
                                                    200) {
                                                  if (onValue['response_code'] ==
                                                          200 &&
                                                      onValue['response_data']
                                                          is Map) {
                                                    Common.setCartData(onValue[
                                                        'response_data']);
                                                  } else {
                                                    Common.setCartData(null);
                                                  }
                                                  for (int i = 0;
                                                      i <
                                                          onValue['response_data']
                                                                  ['products']
                                                              .length;
                                                      i++) {
                                                    if (widget.productData[
                                                            "_id"] ==
                                                        onValue['response_data']
                                                                ['products'][i]
                                                            ["productId"]) {
                                                      if (mounted) {
                                                        setState(() {
                                                          quanity = onValue[
                                                                      'response_data']
                                                                  ['products']
                                                              [i]['quantity'];
                                                          cartId = onValue[
                                                                  'response_data']
                                                              ['_id'];

                                                          cardAdded = true;
                                                        });
                                                      }
                                                    }
                                                  }
                                                }
                                                setState(() {
                                                  isAddInProgress = false;
                                                });
                                              });
                                            }
                                          } else {
                                            showSnackbar(MyLocalizations.of(
                                                        context)
                                                    .getLocalizations(
                                                        "LIMITED_STOCK") +
                                                " ${widget.variantList[0]['productStock']} " +
                                                MyLocalizations.of(context)
                                                    .getLocalizations(
                                                        "OF_THIS_ITEM"));
                                          }
                                        });
                                      }
                                    } else {
                                      if (mounted) {
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Login(
                                                locale: widget.locale,
                                                localizedValues:
                                                    widget.localizedValues,
                                                isBottomSheet: true,
                                              ),
                                            ),
                                          );
                                        });
                                      }
                                    }
                                  });
                                }
                              },
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: primary),
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 5),
                                margin: EdgeInsets.only(top: 5),
                                child: isAddInProgress
                                    ? GFLoader(
                                        type: GFLoaderType.ios,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            MyLocalizations.of(context)
                                                .getLocalizations("ADD"),
                                            style: textbarlowMediumBlackm(),
                                          ),
                                        ],
                                      ),
                              ),
                            )
                          : Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Color(0XFFF0F0F0)),
                              padding: EdgeInsets.only(),
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isQuantityUpdating &&
                                              quantityChangeType == '-'
                                          ? Colors.grey.shade100
                                          : Colors.black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (!isQuantityUpdating) {
                                          quantityChangeType = '-';
                                          _changeProductQuantity(
                                            false,
                                            widget.productData["_id"],
                                          );
                                        }
                                      },
                                      child: isQuantityUpdating &&
                                              quantityChangeType == '-'
                                          ? GFLoader(
                                              type: GFLoaderType.ios,
                                              size: 35,
                                            )
                                          : Icon(
                                              Icons.remove,
                                              color: primary,
                                            ),
                                    ),
                                  ),
                                  Text(quanity == null
                                      ? widget.productData['quantityToCart']
                                          .toString()
                                      : quanity.toString()),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (!isQuantityUpdating) {
                                          quantityChangeType = '+';
                                          if (variantStock > quanity) {
                                            _changeProductQuantity(
                                              true,
                                              widget.productData["_id"],
                                            );
                                          } else {
                                            showSnackbar(
                                                MyLocalizations.of(context)
                                                        .getLocalizations(
                                                            "LIMITED_STOCK") +
                                                    " $variantStock " +
                                                    MyLocalizations.of(context)
                                                        .getLocalizations(
                                                            "OF_THIS_ITEM"));
                                          }
                                        }
                                      },
                                      child: isQuantityUpdating &&
                                              quantityChangeType == '+'
                                          ? GFLoader(
                                              type: GFLoaderType.ios, size: 35)
                                          : Icon(
                                              Icons.add,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
