import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readymadeGroceryApp/model/subscriptionBottomSheet.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/subsription/add_edit_subscriptionPage.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/cardOverlay.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class SubscriptionCard extends StatefulWidget {
  final String? currency;
  final Map? productData;
  final String? locale;
  final Map? localizedValues;

  SubscriptionCard({
    Key? key,
    this.currency,
    this.productData,
    this.locale,
    this.localizedValues,
  }) : super(key: key);

  @override
  _SubscriptionCardState createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  bool cardAdded = false, isAddInProgress = false, isQuantityUpdating = false;
  var variantPrice, variantUnit;
  String? cartId, quantityChangeType = '+';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
                                priceMrpText(getDiscountedValue(), "", context),
                                SizedBox(width: 3),
                                textGreenprimary(
                                    context,
                                    '${variantUnit == null ? widget.productData!['variant'][0]['unit'] : variantUnit}',
                                    barlowregularlack(context))
                              ],
                            ),
                            InkWell(
                                onTap: () async {
                                  if (widget.productData!['variant'].length >
                                      1) {
                                    if (widget.productData != null &&
                                        widget.productData!['variant'] !=
                                            null) {
                                      var bottomSheet = showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext bc) {
                                            return SubsCriptionBottomSheet(
                                              locale: widget.locale,
                                              localizedValues:
                                                  widget.localizedValues,
                                              currency: widget.currency,
                                              productData: widget.productData
                                                  as Map<String, dynamic>?,
                                              variantsList: widget
                                                  .productData!['variant'],
                                            );
                                          });
                                      bottomSheet.then((subProduct) {
                                        if (subProduct != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddEditSubscriptionPage(
                                                        currency:
                                                            widget.currency,
                                                        localizedValues: widget
                                                            .localizedValues,
                                                        locale: widget.locale,
                                                        subProductData:
                                                            subProduct,
                                                        productData: widget
                                                            .productData)),
                                          );
                                        }
                                      });
                                    }
                                  } else {
                                    await Common.getToken().then((onValue) {
                                      if (onValue != null) {
                                        Map subProduct = {
                                          "products": [
                                            {
                                              "productId":
                                                  widget.productData!['_id'],
                                              "productName":
                                                  widget.productData!['title'],
                                              "variantId":
                                                  widget.productData!['variant']
                                                      [0]['_id'],
                                              "unit":
                                                  widget.productData!['variant']
                                                      [0]['unit'],
                                              "subScriptionAmount":
                                                  widget.productData!['variant']
                                                      [0]['subScriptionAmount'],
                                            },
                                          ],
                                        };
                                        subProduct['products'][0]
                                                ["subscriptionTotal"] =
                                            subProduct['products'][0]
                                                    ['subScriptionAmount'] *
                                                1;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddEditSubscriptionPage(
                                                      currency: widget.currency,
                                                      localizedValues: widget
                                                          .localizedValues,
                                                      locale: widget.locale,
                                                      subProductData:
                                                          subProduct,
                                                      productData:
                                                          widget.productData)),
                                        );
                                      } else {
                                        if (mounted) {
                                          setState(() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
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
                                child: subscribeButton(
                                    context,
                                    "${MyLocalizations.of(context)!.getLocalizations("SUBSCRIBE")} @${widget.currency}${widget.productData!['variant'][0]['subScriptionAmount']}",
                                    isAddInProgress))
                          ],
                        ),
                      ),
                    ],
                  ),
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
    return '${widget.currency}${(variantPrice == null ? widget.productData!['variant'][0]['price'] : variantPrice).toDouble().toStringAsFixed(2)}';
  }
}
