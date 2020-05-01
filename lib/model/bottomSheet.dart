import 'package:flutter/material.dart';
import 'package:grocery_pro/model/addToCart.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';

SentryError sentryError = new SentryError();

class BottonSheetClassDryClean extends StatefulWidget {
  final List variantsList;
  final int productQuantity;
  final String currency, locale;
  final Map<String, Map<String, String>> localizedValues;
  final Map<String, dynamic> productList;

  BottonSheetClassDryClean(
      {Key key,
      this.variantsList,
      this.productList,
      this.currency,
      this.productQuantity,
      this.locale,
      this.localizedValues})
      : super(key: key);
  @override
  _BottonSheetClassDryCleanState createState() =>
      _BottonSheetClassDryCleanState();
}

class _BottonSheetClassDryCleanState extends State<BottonSheetClassDryClean> {
  int groupValue = 0;
  bool selectVariant = false, addProductTocart = false, getTokenValue = false;
  int quantity = 1;
  String variantUnit, variantId;
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
    Map<String, dynamic> productAddBody = {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        });
                      }
                    },
                    activeColor: primary,
                    title: new Text(
                      "${widget.currency}${widget.variantsList[index]['price'].toString()}/${widget.variantsList[index]['unit']} ",
                      textAlign: TextAlign.start,
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
                                text: '${quantity.toString()}',
                                style: textBarlowRegularWhite(),
                              ),
                              TextSpan(
                                  text: MyLocalizations.of(context).item,
                                  style: textBarlowRegularWhite()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 1.0,
                        ),
                        new Text(
                          '${widget.currency}${variantPrice == null ? (widget.variantsList[0]['price'] * quantity) : (variantPrice * quantity)}',
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
}
