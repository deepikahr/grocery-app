import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/model/addToCart.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';

SentryError sentryError = new SentryError();

class BottonSheetClassDryClean extends StatefulWidget {
  final List variantsList;
  final int productQuantity;
  final double dealPercentage;
  final String currency, locale;
  final Map<String, Map<String, String>> localizedValues;
  final Map<String, dynamic> productList;

  BottonSheetClassDryClean(
      {Key key,
      this.variantsList,
      this.productList,
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
  String variantUnit, variantId;
  int variantStock;
  var variantPrice;
  @override
  void initState() {
    if (widget.productQuantity == null) {
      quantity = widget.productQuantity;
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
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getTokenValue = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  addToCartMethod() {
    if ((variantStock == null
            ? widget.variantsList[0]['productstock']
            : variantStock) >=
        quantity) {
      Map<String, dynamic> productAddBody = {
        "category": widget.productList['category'],
        "subcategory": widget.productList['subcategory'],
        'productId': widget.productList['_id'].toString(),
        'quantity': quantity,
        "price": double.parse(variantPrice == null
            ? widget.variantsList[0]['price'].toString()
            : variantPrice.toString()),
        "unit": variantUnit == null
            ? widget.variantsList[0]['unit'].toString()
            : variantUnit.toString()
      };
      AddToCart.addToCartMethod(productAddBody).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              addProductTocart = false;
            });
          }
          if (onValue['response_code'] == 200) {
            Navigator.of(context).pop(onValue['response_data']);
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
    } else {
      if (mounted) {
        setState(() {
          addProductTocart = false;
        });
      }

      showSnackbar(MyLocalizations.of(context)
              .limitedquantityavailableyoucantaddmorethan +
          " ${variantStock == null ? widget.variantsList[0]['productstock'] : variantStock} " +
          MyLocalizations.of(context).ofthisitem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    MyLocalizations.of(context).quantity + ':',
                    style: textBarlowMediumBlack(),
                  ),
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
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20.0),
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
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Container(child: Text(quantity.toString())),
                        ),
                        Text(''),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                if ((variantStock == null
                                        ? widget.variantsList[0]['productstock']
                                        : variantStock) >
                                    quantity) {
                                  _changeProductQuantity(true);
                                } else {
                                  showSnackbar(MyLocalizations.of(context)
                                          .limitedquantityavailableyoucantaddmorethan +
                                      " ${variantStock == null ? widget.variantsList[0]['productstock'] : variantStock} " +
                                      MyLocalizations.of(context).ofthisitem);
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
                itemCount: widget.variantsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new RadioListTile(
                    value: index,
                    groupValue: groupValue,
                    selected: selectVariant,
                    onChanged: (int selected) {
                      if (mounted) {
                        setState(() {
                          groupValue = selected;
                          selectVariant = !selectVariant;
                          variantPrice = widget.variantsList[selected]['price'];
                          variantUnit =
                              widget.variantsList[selected]['unit'].toString();
                          variantId =
                              widget.variantsList[selected]['_id'].toString();
                          variantStock =
                              widget.variantsList[selected]['productstock'];
                        });
                      }
                    },
                    activeColor: primary,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.dealPercentage != null
                                  ? "${widget.currency}${((widget.variantsList[index]['price'] - (widget.variantsList[index]['price'] * (widget.dealPercentage / 100)))).toStringAsFixed(2)}"
                                  : '${widget.currency}${(widget.variantsList[index]['price']).toStringAsFixed(2)}',
                              style: textbarlowBoldGreen(),
                            ),
                            SizedBox(width: 3),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: widget.dealPercentage != null
                                  ? Text(
                                      '${widget.currency}${(widget.variantsList[index]['price']).toStringAsFixed(2)}',
                                      style: barlowregularlackstrike(),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                        SizedBox(width: 3),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: widget.dealPercentage != null
                              ? Text(
                                  '${widget.variantsList[index]['unit']} ',
                                  style: textbarlowBoldGreen(),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  );
                }),
            SizedBox(height: 5),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 65.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
              start: 10.0, end: 10.0, bottom: 5.0),
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
                                text: '(${quantity.toString()}) ',
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
                          widget.dealPercentage != null
                              ? '${widget.currency}${((variantPrice == null ? (widget.variantsList[0]['price'] * quantity) : (variantPrice * quantity)) - ((variantPrice == null ? (widget.variantsList[0]['price'] * quantity) : (variantPrice * quantity)) * (widget.dealPercentage / 100))).toStringAsFixed(2)}'
                              : '${widget.currency}${variantPrice == null ? (widget.variantsList[0]['price'] * quantity) : (variantPrice * quantity).toStringAsFixed(2)}',
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
              getToken();
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
