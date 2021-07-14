import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/model/addToCart.dart';
import 'package:readymadeGroceryApp/model/bottomSheet.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/cardOverlay.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class ProductGridCard extends StatefulWidget {
  final String? currency;
  final Map? productData;
  final String? locale;
  final Map? localizedValues;
  final bool? isHome;

  ProductGridCard(
      {Key? key,
      this.currency,
      this.productData,
      this.locale,
      this.localizedValues,
      this.isHome})
      : super(key: key);

  @override
  _ProductGridCardState createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<ProductGridCard> {
  bool? cardAdded = false, isAddInProgress = false, isQuantityUpdating = false;
  var variantPrice, variantUnit, dealPercentage, offerPercentage;
  String? cartId, quantityChangeType = '+';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.productData!['isAddedToCart'] == true) {
      cardAdded = widget.productData!['isAddedToCart'];
    } else {
      cardAdded = false;
    }
    if (widget.productData!['isDealAvailable'] != null &&
        widget.productData!['isDealAvailable'] == true) {
      if (widget.productData!['dealPercent'] != null) {
        dealPercentage =
            double.parse(widget.productData!['dealPercent'].toStringAsFixed(1));
      } else {
        dealPercentage = null;
      }
    } else {
      dealPercentage = null;
    }
    if (widget.productData!['variant'][0]['isOfferAvailable'] != null &&
        widget.productData!['variant'][0]['isOfferAvailable'] == true) {
      if (widget.productData!['variant'][0]['offerPercent'] != null) {
        offerPercentage = double.parse(widget.productData!['variant'][0]
                ['offerPercent']
            .toStringAsFixed(1));
      } else {
        offerPercentage = null;
      }
    } else {
      offerPercentage = null;
    }
    widget.productData!['quantityToCart'] =
        widget.productData!['quantityToCart'] ?? 0;
    super.initState();
  }

  void _changeProductQuantity(bool value) {
    setState(() {
      isQuantityUpdating = true;
    });
    if (value) {
      updateCart(widget.productData!['quantityToCart'], value);
    } else {
      if (widget.productData!['quantityToCart'] > 1) {
        updateCart(widget.productData!['quantityToCart'], value);
      } else {
        deleteCart();
      }
    }
  }

  void updateCart(quanity, increase) async {
    Map<String, dynamic> body = {
      'unit': variantUnit == null
          ? widget.productData!['variant'][0]['unit']
          : variantUnit,
      'productId': widget.productData!["_id"],
    };
    if (increase) {
      body['quantity'] = quanity + 1;
    } else {
      body['quantity'] = quanity - 1;
    }
    await AddToCart.addAndUpdateProductMethod(body).then((onValue) {
      if (onValue['response_data'] is Map) {
        Common.setCartData(onValue['response_data']);
      } else {
        Common.setCartData(null);
      }
      if (mounted) {
        setState(() {
          if (increase) {
            widget.productData!['quantityToCart']++;
          } else {
            widget.productData!['quantityToCart']--;
          }
          isQuantityUpdating = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isQuantityUpdating = false;
        });
      }
    });
  }

  void deleteCart() async {
    await CartService.deleteDataFromCart(widget.productData!["_id"])
        .then((onValue) {
      if (onValue['response_data'] is Map &&
          onValue['response_data']['products'].length == 0 &&
          mounted) {
        setState(() {
          deleteAllCart();
          Common.setCartData(null);
          cardAdded = false;
          isQuantityUpdating = false;
        });
      } else {
        setState(() {
          if (onValue['response_data'] is Map && mounted) {
            Common.setCartData(onValue['response_data']);
          } else {
            Common.setCartData(null);
          }
          cardAdded = false;
          isQuantityUpdating = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isQuantityUpdating = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isQuantityUpdating = false;
        });
      }
    });
  }

  deleteAllCart() async {
    await CartService.deleteAllDataFromCart().then((onValue) {
      Common.setCartData(null);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: bg(context),
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Material(
          type: MaterialType.card,
          color: Theme.of(context).cardColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          borderOnForeground: true,
          clipBehavior: Clip.none,
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl:
                                (widget.productData!['productImages'] != null &&
                                        widget.productData!['productImages']
                                                .length >
                                            0)
                                    ? (widget.productData!['productImages'][0]
                                                ['filePath'] !=
                                            null
                                        ? Constants.imageUrlPath! +
                                            "/tr:dpr-auto,tr:w-500" +
                                            widget.productData!['productImages']
                                                [0]['filePath']
                                        : widget.productData!['productImages']
                                            [0]['imageUrl'])
                                    : widget.productData!['filePath'] != null
                                        ? Constants.imageUrlPath! +
                                            "/tr:dpr-auto,tr:w-500" +
                                            widget.productData!['filePath']
                                        : widget.productData!['imageUrl'],
                            imageBuilder: (context, imageProvider) => Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 123,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 123,
                                child: noDataImage()),
                            errorWidget: (context, url, error) => Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 123,
                                child: noDataImage()),
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: buildProductTitle(
                                        '${widget.productData!['title'][0].toUpperCase()}${widget.productData!['title'].substring(1)}',
                                        context)),
                                widget.productData!['averageRating'] == null ||
                                        widget.productData!['averageRating'] ==
                                            0.0 ||
                                        widget.productData!['averageRating'] ==
                                            '0.0'
                                    ? Container()
                                    : Container(
                                        height: 19,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                          color: Color(0xFF20C978),
                                        ),
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                                widget.productData![
                                                        'averageRating']
                                                    .toStringAsFixed(1),
                                                style: textBarlowregwhite(
                                                    context)),
                                            Icon(Icons.star,
                                                color: Colors.white, size: 10),
                                          ],
                                        ),
                                      )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                priceMrpText(getDiscountedValue(),
                                    getPercentageValue(), context),
                                SizedBox(width: 3),
                                textGreenprimary(
                                    context,
                                    '${variantUnit == null ? widget.productData!['variant'][0]['unit'] : variantUnit}',
                                    barlowregularlack(context))
                              ],
                            ),
                            widget.isHome!
                                ? Container()
                                : !cardAdded!
                                    ? InkWell(
                                        onTap: () async {
                                          if (widget.productData!['variant']
                                                  .length >
                                              1) {
                                            if (widget.productData != null &&
                                                widget.productData![
                                                        'variant'] !=
                                                    null) {
                                              var bottomSheet =
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return BottonSheetClassDryClean(
                                                            locale:
                                                                widget.locale,
                                                            localizedValues: widget
                                                                .localizedValues,
                                                            currency:
                                                                widget.currency,
                                                            productData:
                                                                widget.productData
                                                                    as Map<
                                                                        String,
                                                                        dynamic>?,
                                                            dealPercentage:
                                                                dealPercentage,
                                                            variantsList: widget
                                                                    .productData![
                                                                'variant'],
                                                            productQuantity: widget
                                                                    .productData![
                                                                'quantityToCart']);
                                                      });
                                              bottomSheet.then((onValue) {
                                                if (onValue != null) {
                                                  for (int i = 0;
                                                      i <
                                                          onValue['products']
                                                              .length;
                                                      i++) {
                                                    if (widget.productData![
                                                            "_id"] ==
                                                        onValue['products'][i]
                                                            ["productId"]) {
                                                      if (mounted) {
                                                        setState(() {
                                                          widget.productData![
                                                                  'quantityToCart'] =
                                                              onValue['products']
                                                                      [i]
                                                                  ['quantity'];
                                                          variantPrice =
                                                              onValue['products']
                                                                  [i]['price'];
                                                          cartId =
                                                              onValue['_id'];
                                                          variantUnit = onValue[
                                                                  'products'][i]
                                                              ['unit'];
                                                          cardAdded = true;
                                                        });
                                                      }
                                                    }
                                                  }
                                                }
                                              });
                                            }
                                          } else {
                                            await Common.getToken()
                                                .then((onValue) {
                                              if (onValue != null) {
                                                if (mounted) {
                                                  setState(() {
                                                    if (widget.productData![
                                                                'variant'][0]
                                                            ['productStock'] >
                                                        widget.productData![
                                                            'quantityToCart']) {
                                                      if (!isAddInProgress!) {
                                                        Map<String, dynamic>
                                                            productAddBody = {
                                                          'productId': widget
                                                              .productData![
                                                                  '_id']
                                                              .toString(),
                                                          'quantity': 1,
                                                          "unit": widget
                                                              .productData![
                                                                  'variant'][0]
                                                                  ['unit']
                                                              .toString()
                                                        };
                                                        setState(() {
                                                          isAddInProgress =
                                                              true;
                                                        });
                                                        AddToCart.addAndUpdateProductMethod(
                                                                productAddBody)
                                                            .then((onValue) {
                                                          if (onValue[
                                                                  'response_data']
                                                              is Map) {
                                                            Common.setCartData(
                                                                onValue[
                                                                    'response_data']);
                                                          } else {
                                                            Common.setCartData(
                                                                null);
                                                          }
                                                          for (int i = 0;
                                                              i <
                                                                  onValue['response_data']
                                                                          [
                                                                          'products']
                                                                      .length;
                                                              i++) {
                                                            if (widget.productData![
                                                                    "_id"] ==
                                                                onValue['response_data']
                                                                        [
                                                                        'products'][i]
                                                                    [
                                                                    "productId"]) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  widget.productData![
                                                                      'quantityToCart'] = onValue[
                                                                              'response_data']
                                                                          [
                                                                          'products'][i]
                                                                      [
                                                                      'quantity'];

                                                                  variantPrice =
                                                                      onValue['response_data']['products']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'price'];
                                                                  variantUnit =
                                                                      onValue['response_data']
                                                                              [
                                                                              'products'][i]
                                                                          [
                                                                          'unit'];

                                                                  cardAdded =
                                                                      true;
                                                                });
                                                              }
                                                            }
                                                          }
                                                          setState(() {
                                                            isAddInProgress =
                                                                false;
                                                          });
                                                        }).catchError((error) {
                                                          if (mounted) {
                                                            setState(() {
                                                              isAddInProgress =
                                                                  false;
                                                            });
                                                          }
                                                        });
                                                      }
                                                    } else {
                                                      showSnackbar(MyLocalizations
                                                                  .of(context)!
                                                              .getLocalizations(
                                                                  "LIMITED_STOCK") +
                                                          " ${widget.productData!['variant'][0]['productStock']} " +
                                                          MyLocalizations.of(
                                                                  context)!
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
                                                        builder: (BuildContext
                                                                context) =>
                                                            Login(
                                                          locale: widget.locale,
                                                          localizedValues: widget
                                                              .localizedValues,
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
                                        child: productAddButton(
                                          context,
                                          "ADD",
                                          isAddInProgress,
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
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: isQuantityUpdating! &&
                                                        quantityChangeType ==
                                                            '-'
                                                    ? Colors.grey.shade100
                                                    : Colors.black,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  if (!isQuantityUpdating!) {
                                                    quantityChangeType = '-';
                                                    _changeProductQuantity(
                                                        false);
                                                  }
                                                },
                                                child: isQuantityUpdating! &&
                                                        quantityChangeType ==
                                                            '-'
                                                    ? GFLoader(
                                                        type: GFLoaderType.ios,
                                                        size: 35,
                                                      )
                                                    : Icon(Icons.remove,
                                                        color:
                                                            primary(context)),
                                              ),
                                            ),
                                            titleTwoLine(
                                                widget.productData![
                                                        'quantityToCart']
                                                    .toString(),
                                                context),
                                            Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: primarybg,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  if (!isQuantityUpdating!) {
                                                    quantityChangeType = '+';
                                                    _changeProductQuantity(
                                                        true);
                                                  }
                                                },
                                                child: isQuantityUpdating! &&
                                                        quantityChangeType ==
                                                            '+'
                                                    ? GFLoader(
                                                        type: GFLoaderType.ios,
                                                        size: 35)
                                                    : Icon(
                                                        Icons.add,
                                                        color: Colors.black,
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
                  (widget.productData!['isDealAvailable'] == true &&
                          widget.productData!['variant'][0]
                                  ['isOfferAvailable'] ==
                              true)
                      ? buildBadge(context,
                          widget.productData!['dealPercent'].toString(), "OFF")
                      : (widget.productData!['isDealAvailable'] == true)
                          ? buildBadge(
                              context,
                              widget.productData!['dealPercent'].toString(),
                              "OFF")
                          : (widget.productData!['variant'][0]
                                      ['isOfferAvailable'] ==
                                  true)
                              ? buildBadge(
                                  context,
                                  widget.productData!['variant'][0]
                                          ['offerPercent']
                                      .toString(),
                                  "OFF")
                              : Container()
                ],
              ),
              widget.productData!['variant'].indexWhere(
                          (element) => element['productStock'] == 0) ==
                      -1
                  ? Container()
                  : CardOverlay(),
            ],
          ),
        ),
      ));

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }

  getDiscountedValue() {
    if (dealPercentage != null && offerPercentage != null)
      return '${widget.currency}${((variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice) - ((variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice) * (dealPercentage / 100))).toDouble().toStringAsFixed(2)}';
    else if (dealPercentage != null)
      return '${widget.currency}${((variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice) - ((variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice) * (dealPercentage / 100))).toDouble().toStringAsFixed(2)}';
    else if (offerPercentage != null)
      return '${widget.currency}${((variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice) - ((variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice) * (offerPercentage / 100))).toDouble().toStringAsFixed(2)}';
    else
      return '${widget.currency}${(variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice).toDouble().toStringAsFixed(2)}';
  }

  getPercentageValue() {
    if (dealPercentage != null && offerPercentage != null)
      return '${widget.currency}${(variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice).toDouble().toStringAsFixed(2)}';
    else if (dealPercentage != null)
      return '${widget.currency}${(variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice).toDouble().toStringAsFixed(2)}';
    else if (offerPercentage != null)
      return '${widget.currency}${(variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice).toDouble().toStringAsFixed(2)}';
    else
      return null;
  }
}
