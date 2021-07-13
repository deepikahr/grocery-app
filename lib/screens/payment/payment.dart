import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/payment/payment-webview.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class Payment extends StatefulWidget {
  final String? locale, instruction;
  final Map? data, locationInfo, localizedValues, cartItems;
  Payment(
      {Key? key,
      this.data,
      this.locale,
      this.localizedValues,
      this.locationInfo,
      this.cartItems,
      this.instruction})
      : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? groupValue = 0;
  late String currency;
  bool? isPlaceOrderLoading = false,
      isCardListLoading = false,
      isSelected = false,
      isWalletLoading = false,
      walletUsedOrNotValue = false,
      fullWalletUsedOrNot = false;

  List? paymentTypes = [];
  var walletAmount, cartItem;
  @override
  void initState() {
    fetchCardInfo();
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
    paymentTypes = widget.locationInfo!["paymentMethod"];

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
      showSnackbar(MyLocalizations.of(context)!
          .getLocalizations("SELECT_PAYMENT_FIRST"));
    } else {
      widget.data!['deliveryInstruction'] = widget.instruction ?? "";
      if (fullWalletUsedOrNot == true) {
        widget.data!['paymentType'] = "COD";
        palceOrderMethod(widget.data);
      } else {
        widget.data!['paymentType'] = paymentTypes![groupValue!];
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
      Common.setCartDataCount(0);
      Common.setCartData(null);
      if (cartData['paymentType'] == 'STRIPE') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => PaymentWeViewPage(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  sessionId: onValue['response_data']['sessionId'],
                  orderId: onValue['response_data']['id']),
            ),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Thankyou(
                locale: widget.locale,
                localizedValues: widget.localizedValues,
              ),
            ),
            (Route<dynamic> route) => false);
      }
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
          fullWalletUsedOrNot = false;
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
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarTransparent(context, "PAYMENT") as PreferredSizeWidget?,
      body: isCardListLoading!
          ? SquareLoader()
          : Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20.0, right: 20.0),
              child: ListView(
                children: <Widget>[
                  buildBoldText(context, "CART_SUMMARY"),
                  SizedBox(height: 10),
                  buildPrice(
                      context,
                      null,
                      MyLocalizations.of(context)!
                              .getLocalizations("SUB_TOTAL") +
                          ' ( ${cartItem['products'].length} ' +
                          MyLocalizations.of(context)!
                              .getLocalizations("ITEMS") +
                          ')',
                      '$currency${cartItem['subTotal'].toDouble().toStringAsFixed(2)}',
                      false),
                  SizedBox(height: 10),
                  cartItem['shippingMethod'] == 0
                      ? Container()
                      : buildPriceGreen(
                          context,
                          null,
                          MyLocalizations.of(context)!
                              .getLocalizations("SHIPPING_METHOD"),
                          '${cartItem['shippingMethod']}',
                          false),
                  cartItem['couponCode'] != null
                      ? SizedBox(height: 10)
                      : Container(),
                  cartItem['couponCode'] != null
                      ? buildPrice(
                          context,
                          null,
                          MyLocalizations.of(context)!
                              .getLocalizations("COUPON_DISCOUNT"),
                          '-$currency${cartItem['couponAmount'].toDouble().toStringAsFixed(2)}',
                          false)
                      : Container(),
                  cartItem['tax'] == 0 ? Container() : SizedBox(height: 10),
                  cartItem['tax'] == 0
                      ? Container()
                      : buildPrice(
                          context,
                          null,
                          MyLocalizations.of(context)!.getLocalizations("TAX"),
                          '$currency${cartItem['tax'].toDouble().toStringAsFixed(2)}',
                          false),
                  SizedBox(height: 10),
                  buildPrice(
                      context,
                      null,
                      MyLocalizations.of(context)!
                          .getLocalizations("DELIVERY_CHARGES"),
                      cartItem['deliveryCharges'] == 0 ||
                              cartItem['deliveryCharges'] == "0"
                          ? MyLocalizations.of(context)!
                              .getLocalizations("FREE")
                          : '$currency${cartItem['deliveryCharges'].toDouble().toStringAsFixed(2)}',
                      false),
                  SizedBox(height: 10),
                  cartItem['walletAmount'] > 0
                      ? buildPrice(
                          context,
                          null,
                          MyLocalizations.of(context)!
                              .getLocalizations("PAID_FORM_WALLET"),
                          '-$currency${cartItem['walletAmount'].toDouble().toStringAsFixed(2)}',
                          false)
                      : Container(),
                  cartItem['walletAmount'] > 0
                      ? SizedBox(height: 10)
                      : Container(),
                  buildPrice(
                      context,
                      null,
                      MyLocalizations.of(context)!.getLocalizations("WALLET"),
                      '$currency${(walletAmount - cartItem['walletAmount']).toDouble().toStringAsFixed(2)}',
                      false),
                  walletAmount == null || walletAmount == 0
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            buildPrice(
                                context,
                                null,
                                cartItem['walletAmount'] == 0
                                    ? MyLocalizations.of(context)!
                                        .getLocalizations("APPLY_WALLET")
                                    : MyLocalizations.of(context)!
                                        .getLocalizations("REMOVE_WALLET"),
                                "",
                                isWalletLoading),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Checkbox(
                                    value: walletUsedOrNotValue,
                                    activeColor: Colors.green,
                                    onChanged: (bool? walleValue) {
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
                  Divider(
                      color: Color(0xFF707070).withOpacity(0.20), thickness: 1),
                  buildPrice(
                      context,
                      null,
                      MyLocalizations.of(context)!
                          .getLocalizations("PAYABLE_AMOUNT"),
                      '$currency${cartItem['grandTotal'].toDouble().toStringAsFixed(2)}',
                      false),
                  Divider(
                      color: Color(0xFF707070).withOpacity(0.20), thickness: 1),
                  fullWalletUsedOrNot == true
                      ? Container()
                      : paymentTypes!.length > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildBoldText(context, "CHOOSE_PAYMENT_METHOD"),
                                SizedBox(height: 10),
                                ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: paymentTypes!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      color: whiteBg(context),
                                      child: RadioListTile(
                                        value: index,
                                        groupValue: groupValue,
                                        selected: isSelected!,
                                        activeColor: primary(context),
                                        title: textGreenprimary(
                                            context,
                                            paymentTypes![index],
                                            TextStyle(color: primarybg)),
                                        onChanged: (int? selected) {
                                          if (mounted) {
                                            setState(() {
                                              groupValue = selected;
                                            });
                                          }
                                        },
                                        secondary: paymentTypes![index] == "COD"
                                            ? Text(currency,
                                                style:
                                                    TextStyle(color: primarybg))
                                            : Icon(Icons.credit_card,
                                                color: primarybg, size: 16.0),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          : noDataImage()
                ],
              ),
            ),
      bottomNavigationBar: paymentTypes!.length > 0
          ? InkWell(
              onTap: placeOrder,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: buttonprimary(context, "PAY_NOW", isPlaceOrderLoading),
              ),
            )
          : Container(height: 1),
    );
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
