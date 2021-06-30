import 'package:flutter/material.dart';
import 'package:readymade_grocery_app/model/addToCart.dart';
import 'package:readymade_grocery_app/screens/authe/login.dart';
import 'package:readymade_grocery_app/service/common.dart';
import 'package:readymade_grocery_app/service/localizations.dart';
import 'package:readymade_grocery_app/service/sentry-service.dart';
import 'package:readymade_grocery_app/style/style.dart';
import 'package:readymade_grocery_app/widgets/button.dart';
import 'package:readymade_grocery_app/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class BottonSheetClassDryClean extends StatefulWidget {
  final List? variantsList;
  final int? productQuantity;
  final double? dealPercentage;
  final String? currency, locale;
  final Map? localizedValues;
  final Map? productData;

  BottonSheetClassDryClean(
      {Key? key,
      this.variantsList,
      this.productData,
      this.currency,
      this.productQuantity,
      this.dealPercentage,
      this.locale,
      this.localizedValues})
      : super(key: key);
  @override
  _BottonSheetClassDryCleanState createState() =>
      _BottonSheetClassDryCleanState();
}

class _BottonSheetClassDryCleanState extends State<BottonSheetClassDryClean> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int groupValue = 0;
  bool selectVariant = false, addProductTocart = false, getTokenValue = false;
  int quantity = 1;
  var variantUnit, variantId;
  var variantStock;
  var variantPrice;
  @override
  void initState() {
    if (widget.productQuantity == null) {
      quantity = widget.productQuantity!;
    } else {
      quantity = 1;
    }
    super.initState();
  }

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

  getToken() async {
    if (mounted) {
      setState(() {
        addProductTocart = true;
      });
    }
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            getTokenValue = true;
            addToCartMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            getTokenValue = false;
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isBottomSheet: true,
                ),
              ),
            );
          });
        }
      }
    });
  }

  addToCartMethod() {
    if ((variantStock == null
            ? widget.variantsList![0]['productStock']
            : variantStock) >=
        quantity) {
      Map<String, dynamic> productAddBody = {
        'productId': widget.productData?['_id'].toString(),
        'quantity': quantity,
        "unit": variantUnit == null
            ? widget.variantsList![0]['unit'].toString()
            : variantUnit.toString()
      };
      AddToCart.addAndUpdateProductMethod(productAddBody).then((onValue) {
        if (mounted) {
          setState(() {
            addProductTocart = false;
          });
        }
        if (onValue['message'] != null) {
          showSnackbar(onValue['message'] ?? "");
        }
        Future.delayed(Duration(milliseconds: 1500), () {
          Navigator.of(context).pop(onValue['response_data']);
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
    } else {
      if (mounted) {
        setState(() {
          addProductTocart = false;
        });
      }

      showSnackbar(MyLocalizations.of(context)!
              .getLocalizations("LIMITED_STOCK") +
          " ${variantStock == null ? widget.variantsList![0]['productStock'] : variantStock} " +
          MyLocalizations.of(context)!.getLocalizations("OF_THIS_ITEM"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg(context),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 8.0, left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildGFTypography(context, "QUANTITY", false, true),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30.0)),
                      height: 34,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: dark(context),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                _changeProductQuantity(false);
                              },
                              child: Icon(
                                Icons.remove,
                                color: primary(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Container(
                                child:
                                    titleTwoLine(quantity.toString(), context)),
                          ),
                          Text(''),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: primary(context),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if ((variantStock == null
                                          ? widget.variantsList![0]
                                              ['productStock']
                                          : variantStock) >
                                      quantity) {
                                    _changeProductQuantity(true);
                                  } else {
                                    showSnackbar(MyLocalizations.of(context)!
                                            .getLocalizations("LIMITED_STOCK") +
                                        " ${variantStock == null ? widget.variantsList![0]['productStock'] : variantStock} " +
                                        MyLocalizations.of(context)!
                                            .getLocalizations("OF_THIS_ITEM"));
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
              SizedBox(height: 5),
              ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(right: 0.0),
                  itemCount: widget.variantsList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new RadioListTile(
                      value: index,
                      groupValue: groupValue,
                      selected: selectVariant,
                      onChanged: (int? selected) {
                        if (mounted) {
                          setState(() {
                            groupValue = selected!;
                            selectVariant = !selectVariant;
                            variantPrice =
                                widget.variantsList?[selected]['price'];
                            variantUnit = widget.variantsList?[selected]['unit']
                                .toString();
                            variantId = widget.variantsList?[selected]['_id']
                                .toString();
                            variantStock =
                                widget.variantsList?[selected]['productStock'];
                          });
                        }
                      },
                      activeColor: primary(context),
                      secondary: textGreenprimary(
                          context,
                          '${widget.variantsList?[index]['unit']} ',
                          textbarlowBoldGreen(context)),
                      title: priceMrpText(
                          widget.dealPercentage != null
                              ? "${widget.currency}${((widget.variantsList?[index]['price'] - (widget.variantsList?[index]['price'] * (widget.dealPercentage! / 100)))).toStringAsFixed(2)}"
                              : '${widget.currency}${(widget.variantsList?[index]['price']).toStringAsFixed(2)}',
                          widget.dealPercentage != null
                              ? '${widget.currency}${(widget.variantsList?[index]['price']).toStringAsFixed(2)}'
                              : null,
                          context),
                    );
                  }),
              SizedBox(height: 5),
            ],
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: getToken,
          child: addToCartButton(
              context,
              '(${quantity.toString()})  ',
              widget.dealPercentage != null
                  ? '${widget.currency}${((variantPrice == null ? (widget.variantsList?[0]['price'] * quantity) : (variantPrice * quantity)) - ((variantPrice == null ? (widget.variantsList?[0]['price'] * quantity) : (variantPrice * quantity)) * (widget.dealPercentage! / 100))).toStringAsFixed(2)}'
                  : '${widget.currency}${variantPrice == null ? (widget.variantsList?[0]['price'] * quantity) : (variantPrice * quantity).toStringAsFixed(2)}',
              "ADD_TO_CART",
              Icon(Icons.shopping_cart, color: dark(context)),
              addProductTocart),
        ));
  }

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }
}
