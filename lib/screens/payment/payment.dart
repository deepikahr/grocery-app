import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';

import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:stripe_payment/stripe_payment.dart';

SentryError sentryError = new SentryError();

class Payment extends StatefulWidget {
  final int quantity, currentIndex;
  final String type, locale;
  final grandTotals, deliveryCharges;
  final Map<String, dynamic> data, locationInfo;
  final Map localizedValues;

  Payment(
      {Key key,
      this.data,
      this.quantity,
      this.currentIndex,
      this.type,
      this.deliveryCharges,
      this.grandTotals,
      this.locale,
      this.localizedValues,
      this.locationInfo})
      : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int groupValue = 0;
  var walletAmount, usedWalletAmount = 0.0;
  String currency;
  var grandTotal, deliveryCharges, remaingWalletPoints, grandTotalCalulation;
  bool isPlaceOrderLoading = false,
      isCardListLoading = false,
      isSelected = false,
      walletUsedOrNotValue = false,
      showPaymantOptions = false;

  List paymentTypes = [];

  @override
  void initState() {
    fetchCardInfo();
    StripePayment.setOptions(StripeOptions(
        publishableKey: Constants.stripKey,
        merchantId: "Test",
        androidPayMode: 'test'));

    deliveryCharges = widget.deliveryCharges;
    grandTotal = widget.grandTotals;

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
      try {
        if (mounted) {
          setState(() {
            walletAmount = onValue['response_data']['walletAmount'] ?? 0;
            isCardListLoading = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  placeOrder() async {
    if (mounted) {
      setState(() {
        isPlaceOrderLoading = true;
      });
    }
    if (showPaymantOptions == false) {
      if (groupValue == null) {
        if (mounted) {
          setState(() {
            isPlaceOrderLoading = false;
          });
        }
        showSnackbar(MyLocalizations.of(context)
            .getLocalizations("SELECT_PAYMENT_FIRST"));
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
    } else {
      palceOrderMethod(widget.data);
    }
  }

  palceOrderMethod(cartData) async {
    await OrderService.placeOrder(cartData).then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isPlaceOrderLoading = false;
          });
        }
        if (onValue['response_code'] == 200) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Thankyou(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                ),
              ),
              (Route<dynamic> route) => false);
        } else {
          verifyTokenAlert(onValue['response_data']);
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isPlaceOrderLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
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

  verifyTokenAlert(responseData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            MyLocalizations.of(context).getLocalizations("OUT_OF_STOCK"),
          ),
          content: SingleChildScrollView(
            child: responseData.length > 0
                ? ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: responseData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            responseData[index]['productName'].toString(),
                          ),
                          Text(
                            responseData[index]['unit'].toString() +
                                "*" +
                                responseData[index]['quantity'].toString(),
                          ),
                        ],
                      );
                    })
                : Text(""),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(MyLocalizations.of(context).getLocalizations("OK")),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currentIndex: 2,
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    grandTotalCalulation = null;
    remaingWalletPoints = null;
    paymentTypes = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        title: Text(
          MyLocalizations.of(context).getLocalizations("PAYMENT"),
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
      body: isCardListLoading
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                deliveryCharges == 0 || deliveryCharges == "0"
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
                                        deliveryCharges
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
                                  grandTotalCalulation != null
                                      ? grandTotalCalulation
                                          .toDouble()
                                          .toStringAsFixed(2)
                                      : grandTotal
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
                                            remaingWalletPoints != null
                                                ? remaingWalletPoints
                                                    .toDouble()
                                                    .toStringAsFixed(2)
                                                : walletAmount
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
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        MyLocalizations.of(context)
                                            .getLocalizations(
                                                "USE_WALLET_AMOUNT"),
                                        style: textbarlowMediumBlack(),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          new Checkbox(
                                              value: walletUsedOrNotValue,
                                              activeColor: Colors.green,
                                              onChanged: (bool newValue) {
                                                setState(() {
                                                  walletUsedOrNotValue =
                                                      newValue;
                                                  if (walletUsedOrNotValue ==
                                                      true) {
                                                    if (walletAmount >=
                                                        grandTotal) {
                                                      remaingWalletPoints =
                                                          walletAmount -
                                                              grandTotal;
                                                      grandTotalCalulation =
                                                          0.0;
                                                      showPaymantOptions = true;
                                                    } else {
                                                      grandTotalCalulation =
                                                          grandTotal -
                                                              walletAmount;
                                                      remaingWalletPoints = 0.0;
                                                      showPaymantOptions =
                                                          false;
                                                    }
                                                    usedWalletAmount =
                                                        walletAmount -
                                                            remaingWalletPoints;
                                                  } else {
                                                    remaingWalletPoints =
                                                        walletAmount;
                                                    grandTotalCalulation =
                                                        grandTotal;
                                                    usedWalletAmount = 0.0;
                                                    showPaymantOptions = false;
                                                  }
                                                });
                                              }),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 10),
                showPaymantOptions == true
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
          ? Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
              height: 55,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.33), blurRadius: 6)
              ]),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 0.0,
                  right: 0.0,
                ),
                child: GFButton(
                  color: primary,
                  blockButton: true,
                  onPressed: placeOrder,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).getLocalizations("PAY_NOW"),
                        style: textBarlowRegularBlack(),
                      ),
                      isPlaceOrderLoading
                          ? GFLoader(
                              type: GFLoaderType.ios,
                            )
                          : Text("")
                    ],
                  ),
                  textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
            )
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
