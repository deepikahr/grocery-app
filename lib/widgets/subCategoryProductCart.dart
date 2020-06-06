import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final image,
      title,
      variantStock,
      price,
      currency,
      isPath,
      unit,
      rating,
      category,
      offer,
      productQuantity,
      buttonName,
      cartId,
      subCategoryId;
  final double dealPercentage;
  final bool token, cartAdded;
  final Map productList;
  final List variantList;
  final String locale;
  final Map localizedValues;
  SubCategoryProductCard(
      {Key key,
      this.image,
      this.variantStock,
      this.subCategoryId,
      this.title,
      this.unit,
      this.isPath,
      this.price,
      this.currency,
      this.rating,
      this.dealPercentage,
      this.category,
      this.offer,
      this.productQuantity,
      this.cartAdded,
      this.buttonName,
      this.productList,
      this.variantList,
      this.locale,
      this.token,
      this.cartId,
      this.localizedValues})
      : super(key: key);
  @override
  _SubCategoryProductCardState createState() => _SubCategoryProductCardState();
}

class _SubCategoryProductCardState extends State<SubCategoryProductCard> {
  int quanity;
  bool cardAdded = false, isAddInProgress = false, isQuantityUpdating = false;
  var variantPrice, variantStock, variantUnit;
  String cartId, quantityChangeType = '+';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.cartAdded == true) {
      cardAdded = widget.cartAdded;
    } else {
      cardAdded = false;
    }
    if (widget.variantStock != null) {
      variantStock = widget.variantStock;
    }

    quanity = widget.productQuantity;

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
      'cartId': cartId == null ? widget.cartId : cartId,
      'productId': id,
      'quantity': quanity
    };
    await CartService.updateProductToCart(body).then((onValue) {
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
    Map<String, dynamic> body = {
      'cartId': cartId == null ? widget.cartId : cartId,
      'productId': id,
    };

    await CartService.deleteDataFromCart(body).then((onValue) {
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
                    widget.isPath
                        ? Constants.IMAGE_URL_PATH +
                            "tr:dpr-auto,tr:w-500" +
                            widget.image
                        : widget.image,
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
                              widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textbarlowRegularBlackb(),
                            ),
                          ),
                          widget.rating == null ||
                                  widget.rating == 0.0 ||
                                  widget.rating == '0.0'
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
                                      Text(widget.rating,
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
                                widget.dealPercentage == null
                                    ? '${widget.currency}${(variantPrice == null ? widget.price : variantPrice).toDouble().toStringAsFixed(2)}'
                                    : '${widget.currency}${((variantPrice == null ? widget.price : variantPrice) - ((variantPrice == null ? widget.price : variantPrice) * (widget.dealPercentage / 100))).toDouble().toStringAsFixed(2)}',
                                style: textbarlowBoldgreen(),
                              ),
                              SizedBox(width: 3),
                              widget.dealPercentage == null
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
                              '${variantUnit == null ? widget.unit : variantUnit}',
                              style: barlowregularlack(),
                            ),
                          )
                        ],
                      ),
                      !cardAdded
                          ? InkWell(
                              onTap: () async {
                                if (widget.variantList.length > 1) {
                                  if (widget.productList != null &&
                                      widget.variantList != null) {
                                    var bottomSheet = showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return BottonSheetClassDryClean(
                                              locale: widget.locale,
                                              localizedValues:
                                                  widget.localizedValues,
                                              currency: widget.currency,
                                              productList: widget.productList,
                                              dealPercentage:
                                                  widget.dealPercentage,
                                              variantsList: widget.variantList,
                                              productQuantity: quanity == null
                                                  ? widget.productQuantity
                                                  : quanity);
                                        });
                                    bottomSheet.then((onValue) {
                                      for (int i = 0;
                                          i < onValue['cart'].length;
                                          i++) {
                                        if (widget.productList["_id"] ==
                                            onValue['cart'][i]["productId"]) {
                                          if (mounted) {
                                            setState(() {
                                              quanity = onValue['cart'][i]
                                                  ['quantity'];
                                              variantPrice =
                                                  onValue['cart'][i]['price'];
                                              cartId = onValue['_id'];
                                              variantUnit =
                                                  onValue['cart'][i]['unit'];
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
                                                  ['productstock'] >
                                              quanity) {
                                            if (!isAddInProgress) {
                                              Map<String, dynamic>
                                                  productAddBody = {
                                                "category": widget
                                                    .productList['category'],
                                                "subcategory": widget
                                                    .productList['subcategory'],
                                                'productId': widget
                                                    .productList['_id']
                                                    .toString(),
                                                'quantity': 1,
                                                "price": double.parse(widget
                                                    .variantList[0]['price']
                                                    .toString()),
                                                "unit": widget.variantList[0]
                                                        ['unit']
                                                    .toString()
                                              };
                                              setState(() {
                                                isAddInProgress = true;
                                              });
                                              AddToCart.addToCartMethod(
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
                                                                  ['cart']
                                                              .length;
                                                      i++) {
                                                    if (widget.productList[
                                                            "_id"] ==
                                                        onValue['response_data']
                                                                ['cart'][i]
                                                            ["productId"]) {
                                                      if (mounted) {
                                                        setState(() {
                                                          quanity = onValue[
                                                                      'response_data']
                                                                  ['cart'][i]
                                                              ['quantity'];
                                                          cartId = onValue[
                                                                  'response_data']
                                                              ['_id'];
                                                          variantStock = widget
                                                                  .variantList[0]
                                                              ['productstock'];

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
                                                    .limitedquantityavailableyoucantaddmorethan +
                                                " ${widget.variantList[0]['productstock']} " +
                                                MyLocalizations.of(context)
                                                    .ofthisitem);
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
                                            widget.buttonName,
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
                                    height: 35,
                                    width: 35,
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: isQuantityUpdating &&
                                                quantityChangeType == '-'
                                            ? Colors.grey.shade100
                                            : Colors.black),
                                    child: InkWell(
                                      onTap: () async {
                                        if (!isQuantityUpdating) {
                                          quantityChangeType = '-';
                                          _changeProductQuantity(
                                            false,
                                            widget.productList["_id"],
                                          );
                                        }
                                      },
                                      child: isQuantityUpdating &&
                                              quantityChangeType == '-'
                                          ? GFLoader(
                                              type: GFLoaderType.ios,
                                              size: 35,
                                            )
                                          : SvgPicture.asset(
                                              'lib/assets/icons/delete.svg',
                                            ),
                                    ),
                                  ),
                                  Text(quanity == null
                                      ? widget.productQuantity.toString()
                                      : quanity.toString()),
                                  Container(
                                    height: 35,
                                    width: 35,
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: isQuantityUpdating &&
                                                quantityChangeType == '+'
                                            ? Colors.grey.shade100
                                            : primary),
                                    child: InkWell(
                                      onTap: () async {
                                        if (!isQuantityUpdating) {
                                          quantityChangeType = '+';
                                          if (variantStock > quanity) {
                                            _changeProductQuantity(
                                              true,
                                              widget.productList["_id"],
                                            );
                                          } else {
                                            showSnackbar(MyLocalizations.of(
                                                        context)
                                                    .limitedquantityavailableyoucantaddmorethan +
                                                " $variantStock " +
                                                MyLocalizations.of(context)
                                                    .ofthisitem);
                                          }
                                        }
                                      },
                                      child: isQuantityUpdating &&
                                              quantityChangeType == '+'
                                          ? GFLoader(
                                              type: GFLoaderType.ios, size: 35)
                                          : SvgPicture.asset(
                                              'lib/assets/icons/add1.svg'),
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
