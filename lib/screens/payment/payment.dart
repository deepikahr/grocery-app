import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';

import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:stripe_payment/stripe_payment.dart';

SentryError sentryError = new SentryError();

class Payment extends StatefulWidget {
  final String locale;

  final Map data, locationInfo, localizedValues, cartItems;

  Payment(
      {Key key,
      this.data,
      this.locale,
      this.localizedValues,
      this.locationInfo,
      this.cartItems})
      : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int groupValue = 0;
  String currency;
  bool isPlaceOrderLoading = false,
      isCardListLoading = false,
      isSelected = false,
      isWalletLoading = false,
      walletUsedOrNotValue = false,
      fullWalletUsedOrNot = false;

  List paymentTypes = [];
  var walletAmount, cartItem;
  @override
  void initState() {
    fetchCardInfo();
    StripePayment.setOptions(StripeOptions(
        publishableKey: Constants.stripKey,
        merchantId: "Test",
        androidPayMode: 'test'));
    cartItem = widget.cartItems;
    if (cartItem['walletAmount'] > 0) {
      walletUsedOrNotValue = true;
      if (cartItem['grandTotal'] == 0) {
        fullWalletUsedOrNot = true;
      }
    }
    super.initState();
  }

  fetchCardInfo() async {
    if (mounted) {
      setState(() {
        isCardListLoading = true;
      });
    }
    getUserInfo();
    paymentTypes = widget.locationInfo["paymentMethod"];
    if (paymentTypes.length > 0) {
      widget.data['paymentType'] = paymentTypes[groupValue];
    }

    await Common.getCurrency().then((value) {
      currency = value;
    });
  }

  getUserInfo() async {
    await LoginService.getUserInfo().then((onValue) {
      if (mounted) {
        setState(() {
          walletAmount = onValue['response_data']['walletAmount'] ?? 0;
          isCardListLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          walletAmount = 0;
          isCardListLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  placeOrder() async {
    if (mounted) {
      setState(() {
        isPlaceOrderLoading = true;
      });
    }
    if (groupValue == null) {
      if (mounted) {
        setState(() {
          isPlaceOrderLoading = false;
        });
      }
      showSnackbar(
          MyLocalizations.of(context).getLocalizations("SELECT_PAYMENT_FIRST"));
    } else {
      if (widget.data['paymentType'] == "CARD") {
        StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
            .then((pm) {
          setState(() {
            widget.data['paymentId'] = pm.id.toString();
            palceOrderMethod(widget.data);
          });
        }).catchError((e) {
          if (mounted) {
            setState(() {
              isPlaceOrderLoading = false;
            });
          }
          showSnackbar(e.toString());
        });
      } else {
        palceOrderMethod(widget.data);
      }
    }
  }

  palceOrderMethod(cartData) async {
    await OrderService.placeOrder(cartData).then((onValue) {
      if (mounted) {
        setState(() {
          isPlaceOrderLoading = false;
        });
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Thankyou(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
            ),
          ),
          (Route<dynamic> route) => false);
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isPlaceOrderLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  applyWallet(walleValue) async {
    if (mounted) {
      setState(() {
        isWalletLoading = true;
      });
    }
    await CartService.walletApply().then((onValue) {
      if (mounted) {
        setState(() {
          isWalletLoading = false;
          cartItem = onValue['response_data'];
          walletUsedOrNotValue = walleValue;
          if (cartItem['grandTotal'] == 0) {
            fullWalletUsedOrNot = true;
          }
        });
      }
    }).catchError((error) {
      setState(() {
        isWalletLoading = false;
        walletUsedOrNotValue = false;
      });
      sentryError.reportError(error, null);
    });
  }

  removeWallet(walleValue) async {
    if (mounted) {
      setState(() {
        isWalletLoading = true;
      });
    }
    await CartService.walletRemove().then((onValue) {
      if (mounted) {
        setState(() {
          isWalletLoading = false;
          cartItem = onValue['response_data'];
          walletUsedOrNotValue = walleValue;
        });
      }
    }).catchError((error) {
      setState(() {
        isWalletLoading = true;
        walletUsedOrNotValue = false;
      });
      sentryError.reportError(error, null);
    });
  }

  @override
  void dispose() {
    paymentTypes = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarTransparent(context, "PAYMENT"),
      body: isCardListLoading
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                cartItem['deliveryCharges'] == 0 ||
                        cartItem['deliveryCharges'] == "0"
                    ? Container()
                    : Container(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations(
                                            "DELIVERY_CHARGES", true),
                                    style: textbarlowMediumBlack(),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Text(
                                          currency,
                                          style: textbarlowBoldBlack(),
                                        ),
                                      ),
                                      Text(
                                        cartItem['deliveryCharges']
                                            .toDouble()
                                            .toStringAsFixed(2),
                                        style: textbarlowBoldBlack(),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("TOTAL", true),
                              style: textbarlowMediumBlack(),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    currency,
                                    style: textbarlowBoldBlack(),
                                  ),
                                ),
                                Text(
                                  cartItem['grandTotal']
                                      .toDouble()
                                      .toStringAsFixed(2),
                                  style: textbarlowBoldBlack(),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                walletAmount == null || walletAmount == 0
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        MyLocalizations.of(context)
                                            .getLocalizations(
                                                "TOTAL_WALLET_AMOUNT"),
                                        style: textbarlowMediumBlack(),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0.0),
                                            child: Text(
                                              currency,
                                              style: textbarlowBoldBlack(),
                                            ),
                                          ),
                                          Text(
                                            (walletAmount -
                                                    cartItem['walletAmount'])
                                                .toDouble()
                                                .toStringAsFixed(2),
                                            style: textbarlowBoldBlack(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    cartItem['walletAmount'] == 0
                                        ? MyLocalizations.of(context)
                                            .getLocalizations(
                                                "USE_WALLET_AMOUNT")
                                        : MyLocalizations.of(context)
                                                .getLocalizations(
                                                    "USED_WALLET_AMOUNT") +
                                            " " +
                                            currency +
                                            cartItem['walletAmount']
                                                .toDouble()
                                                .toStringAsFixed(2),
                                    style: textbarlowMediumBlack(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      isWalletLoading == true
                                          ? Container(child: SquareLoader())
                                          : new Checkbox(
                                              value: walletUsedOrNotValue,
                                              activeColor: Colors.green,
                                              onChanged: (bool walleValue) {
                                                setState(() {
                                                  if (walleValue == true) {
                                                    applyWallet(walleValue);
                                                  } else {
                                                    removeWallet(walleValue);
                                                  }
                                                });
                                              }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 10),
                fullWalletUsedOrNot == true
                    ? Container()
                    : paymentTypes.length > 0
                        ? Column(
                            children: [
                              ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.only(right: 0.0),
                                itemCount: paymentTypes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.all(8.0),
                                    color: Colors.white,
                                    child: RadioListTile(
                                      value: index,
                                      groupValue: groupValue,
                                      selected: isSelected,
                                      activeColor: primary,
                                      title: Text(
                                        paymentTypes[index] == 'COD'
                                            ? MyLocalizations.of(context)
                                                .getLocalizations(
                                                    "CASH_ON_DELIVERY")
                                            : MyLocalizations.of(context)
                                                .getLocalizations(
                                                    "PAY_BY_CARD"),
                                        style: TextStyle(color: primary),
                                      ),
                                      onChanged: (int selected) {
                                        if (mounted) {
                                          setState(() {
                                            groupValue = selected;
                                            widget.data['paymentType'] =
                                                paymentTypes[groupValue];
                                          });
                                        }
                                      },
                                      secondary: paymentTypes[index] == "COD"
                                          ? Text(
                                              currency,
                                              style: TextStyle(color: primary),
                                            )
                                          : Icon(
                                              Icons.credit_card,
                                              color: primary,
                                              size: 16.0,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : Center(
                            child:
                                Image.asset('lib/assets/images/no-orders.png'),
                          )
              ],
            ),
      bottomNavigationBar: paymentTypes.length > 0
          ? InkWell(
              onTap: placeOrder,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: buttonPrimary(context, "PAY_NOW", isPlaceOrderLoading),
              ))

          // Container(
          //     margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
          //     height: 55,
          //     decoration: BoxDecoration(boxShadow: [
          //       BoxShadow(color: Colors.black.withOpacity(0.33), blurRadius: 6)
          //     ]),
          //     child: Padding(
          //       padding: const EdgeInsets.only(
          //         left: 0.0,
          //         right: 0.0,
          //       ),
          //       child: GFButton(
          //         color: primary,
          //         blockButton: true,
          //         onPressed: placeOrder,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: <Widget>[
          //             Text(
          //               MyLocalizations.of(context).getLocalizations("PAY_NOW"),
          //               style: textBarlowRegularBlack(),
          //             ),
          //             isPlaceOrderLoading
          //                 ? GFLoader(
          //                     type: GFLoaderType.ios,
          //                   )
          //                 : Text("")
          //           ],
          //         ),
          //         textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
          //       ),
          //     ),
          //   )
          : Container(height: 1),
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
