import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_pro/model/addToCart.dart';
import 'package:grocery_pro/model/bottomSheet.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/service/cart-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:flutter/cupertino.dart';

class SubCategoryProductCard extends StatefulWidget {
  final image,
      title,
      price,
      currency,
      rating,
      category,
      offer,
      productQuantity,
      nullImage,
      buttonName,
      cartId;
  final bool token, cartAdded;
  final Map productList;
  final List variantList;
  final String locale;
  final Map<String, Map<String, String>> localizedValues;
  SubCategoryProductCard(
      {Key key,
      this.image,
      this.title,
      this.price,
      this.currency,
      this.rating,
      this.category,
      this.offer,
      this.productQuantity,
      this.cartAdded,
      this.nullImage,
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
  bool cardAdded = false;
  var variantPrice;
  String cartId;
  @override
  void initState() {
    if (widget.cartAdded == true) {
      cardAdded = widget.cartAdded;
    } else {
      cardAdded = false;
    }

    quanity = widget.productQuantity;

    super.initState();
  }

  void _changeProductQuantity(bool increase, id) {
    if (increase) {
      if (mounted) {
        setState(() {
          quanity++;
          updateCart(quanity, id);
        });
      }
    } else {
      if (quanity > 1) {
        if (mounted) {
          setState(() {
            quanity--;
            updateCart(quanity, id);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            deleteCart(id);
          });
        }
      }
    }
  }

  updateCart(quanity, id) async {
    Map<String, dynamic> body = {
      'cartId': cartId == null ? widget.cartId : cartId,
      'productId': id,
      'quantity': quanity
    };
    await CartService.updateProductToCart(body).then((onValue) {});
  }

  deleteCart(id) async {
    Map<String, dynamic> body = {
      'cartId': cartId == null ? widget.cartId : cartId,
      'productId': id,
    };

    await CartService.deleteDataFromCart(body).then((onValue) {
      if (mounted) {
        setState(() {
          cardAdded = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = CardTheme.of(context);
    final double _defaultElevation = 1;
    final Clip _defaultClipBehavior = Clip.none;
    return Container(
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
              child: widget.image == null
                  ? Image.asset(widget.nullImage)
                  : Image.network(
                      widget.image,
                      fit: BoxFit.fill,
                      height: 120,
                      width: MediaQuery.of(context).size.width,
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
                          style: textbarlowRegularBlackb(),
                        ),
                      ),
                      Container(
                        height: 19,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          color: Color(0xFF20C978),
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(widget.rating == null ? '0' : widget.rating,
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
                      Expanded(
                        child: Text(
                          '${widget.currency}${variantPrice == null ? widget.price : variantPrice}',
                          style: textbarlowBoldgreen(),
                        ),
                      ),
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
                                          quanity =
                                              onValue['cart'][i]['quantity'];
                                          variantPrice =
                                              onValue['cart'][i]['price'];
                                          cartId = onValue['_id'];
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
                                      Map<String, dynamic> productAddBody = {
                                        'productId': widget.productList['_id']
                                            .toString(),
                                        'quantity': 1,
                                        "price": double.parse(widget
                                            .variantList[0]['price']
                                            .toString()),
                                        "unit": widget.variantList[0]['unit']
                                            .toString()
                                      };
                                      AddToCart.addToCartMethod(productAddBody)
                                          .then((onValue) {
                                        if (onValue['response_code'] == 200) {
                                          for (int i = 0;
                                              i <
                                                  onValue['response_data']
                                                          ['cart']
                                                      .length;
                                              i++) {
                                            if (widget.productList["_id"] ==
                                                onValue['response_data']['cart']
                                                    [i]["productId"]) {
                                              if (mounted) {
                                                setState(() {
                                                  quanity =
                                                      onValue['response_data']
                                                              ['cart'][i]
                                                          ['quantity'];
                                                  cartId =
                                                      onValue['response_data']
                                                          ['_id'];
                                                  cardAdded = true;
                                                });
                                              }
                                            }
                                          }
                                        }
                                      });
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, bottom: 5),
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 35,
                                width: 35,
                                padding: EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.black),
                                child: InkWell(
                                  onTap: () async {
                                    _changeProductQuantity(
                                      false,
                                      widget.productList["_id"],
                                    );
                                  },
                                  child: SvgPicture.asset(
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: primary),
                                child: InkWell(
                                  onTap: () async {
                                    _changeProductQuantity(
                                      true,
                                      widget.productList["_id"],
                                    );
                                  },
                                  child: SvgPicture.asset(
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
    );
  }
}
