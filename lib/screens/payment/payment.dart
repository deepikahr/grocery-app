import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/payment-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';

SentryError sentryError = new SentryError();

class Payment extends StatefulWidget {
  final int quantity, currentIndex;
  final String type, locale;
  final grandTotals, deliveryCharges;

  final Map<String, dynamic> data;
  final Map<String, Map<String, String>> localizedValues;

  Payment(
      {Key key,
      this.data,
      this.quantity,
      this.currentIndex,
      this.type,
      this.deliveryCharges,
      this.grandTotals,
      this.locale,
      this.localizedValues})
      : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int selectedRadio,
      cashOnDelivery = 0,
      payByCard = 1,
      groupValue,
      cardValue = 0;
  String paymentType, cvv, selectedPaymentType, cardID, currency;
  var grandTotal, deliveryCharges;
  bool isPlaceOrderLoading = false,
      ispaymentMethodLoading = false,
      isFirstTime = true,
      isCardDelete = false,
      isCardListLoading = false,
      isSelected = false;
  var paymentMethodValue;
  List cardList;
  var cardDetails;
  String paymentMethodId;
  List<Map<String, dynamic>> paymentTypes = [
    {
      'type': 'COD',
      'icon': Icons.attach_money,
      'gateway': 'COD',
      'isSelected': true
    },
    {
      'type': 'CARD',
      'icon': Icons.credit_card,
      'gateway': 'CARD',
      'isSelected': false
    },
  ];

  @override
  void initState() {
    fetchCardInfo();
    StripePayment.setOptions(StripeOptions(
        publishableKey: Constants.STRIPE_KEY,
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await PaymentService.getCardList().then((onValue) {
      try {
        _refreshController.refreshCompleted();

        if (mounted) {
          setState(() {
            cardList = onValue['response_data'];
            isCardListLoading = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            cardList = [];
            isCardListLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          cardList = [];
          isCardListLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  deleteCard(id) async {
    if (mounted) {
      setState(() {
        isCardDelete = true;
      });
    }
    await PaymentService.deleteCard(id).then((onValue) {
      if (mounted) {
        setState(() {
          fetchCardInfo();
          isCardDelete = false;
          Navigator.pop(context);
        });
      }
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
      showSnackbar(MyLocalizations.of(context).selectPaymentMethod);
    } else {
      widget.data['paymentType'] = paymentTypes[groupValue]['type'];

      if (widget.data['paymentType'] == "CARD") {
        StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
            .then((pm) {
          setState(() {
            Map transactionDetails = {"paymentMethodId": pm.id.toString()};
            widget.data['transactionDetails'] = transactionDetails;
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
    await ProductService.placeOrder(cartData).then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isPlaceOrderLoading = false;
          });
        }
        if (onValue['response_code'] == 201) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Thankyou(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                ),
              ),
              (Route<dynamic> route) => false);
        } else if (onValue['response_code'] == 400) {
          showSnackbar("${onValue['response_data']}");
        } else if (onValue['response_code'] == 403) {
          verifyTokenAlert(onValue['response_data'], cartData['cart']);
        } else {
          showSnackbar("${onValue['response_data']}");
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

  verifyTokenAlert(responseData, cartId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            responseData['message'],
          ),
          content: SingleChildScrollView(
            child: responseData['cartVerifyData']['cartArr'].length > 0
                ? ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: responseData['cartVerifyData']['cartArr'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        responseData['cartVerifyData']['cartArr'][index]
                                ['title']
                            .toString(),
                      );
                    })
                : Text(""),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(MyLocalizations.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(MyLocalizations.of(context).removeItem),
              onPressed: () {
                Map body = {
                  "cartId": cartId,
                  "cart": responseData['cartVerifyData']['cartArr']
                };
                CartService.paymentTimeCarDataDelete(body).then((response) {
                  if (response['response_code'] == 200) {
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
                  } else {
                    showSnackbar("${response['response_data']}");
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      paymentMethodValue = 'COD';
      isFirstTime = false;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        title: Text(
          MyLocalizations.of(context).payment,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          fetchCardInfo();

          deliveryCharges = widget.deliveryCharges;
          grandTotal = widget.grandTotals;
        },
        child: isCardListLoading
            ? SquareLoader()
            : ListView(
                children: <Widget>[
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
                                MyLocalizations.of(context).deliveryCharges,
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
                                MyLocalizations.of(context).grandTotal,
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
                                    grandTotal.toDouble().toStringAsFixed(2),
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
                  SizedBox(height: 10),
                  Column(
                    children: [
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(right: 0.0),
                        itemCount: paymentTypes.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (grandTotal >= 0.5) {
                            paymentTypes[0]['isSelected'] = true;
                            paymentTypes[1]['isSelected'] = true;
                          } else {
                            paymentTypes[0]['isSelected'] = true;
                            paymentTypes[1]['isSelected'] = false;
                          }
                          return paymentTypes[index]['isSelected'] == true
                              ? Container(
                                  margin: EdgeInsets.all(8.0),
                                  color: Colors.white,
                                  child: RadioListTile(
                                    value: index,
                                    groupValue: groupValue,
                                    selected: isSelected,
                                    activeColor: primary,
                                    title: Text(
                                      paymentTypes[index]['type'] == 'COD'
                                          ? MyLocalizations.of(context)
                                              .cashOnDelivery
                                          : MyLocalizations.of(context)
                                              .payByCard,
                                      style: TextStyle(color: primary),
                                    ),
                                    onChanged: (int selected) {
                                      if (mounted) {
                                        setState(() {
                                          groupValue = selected;
                                        });
                                      }
                                    },
                                    secondary: paymentTypes[index]['type'] ==
                                            "COD"
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
                                )
                              : Container();
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Container(
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
                  MyLocalizations.of(context).payNow,
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
