import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:readymadeGroceryApp/screens/payment/tapPaymnetWebView.dart';
import 'package:readymadeGroceryApp/screens/thank-you/payment-failed.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/alert-service.dart';
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
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

SentryError sentryError = new SentryError();

class Payment extends StatefulWidget {
  final String? locale, instruction;
  final Map? data, localizedValues, cartItems;
  Payment(
      {Key? key,
      this.data,
      this.locale,
      this.localizedValues,
      this.cartItems,
      this.instruction})
      : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? groupValue = 0;
  String? currency;
  bool isPlaceOrderLoading = false,
      isCardListLoading = false,
      isSelected = false,
      isWalletLoading = false,
      walletUsedOrNotValue = false,
      fullWalletUsedOrNot = false;

  List paymentTypes = [];
  var walletAmount, cartItem;
  Razorpay? _razorpay;
  Map? userInfo;
  Map<dynamic, dynamic>? tapSDKResult;
  String? sdkErrorCode;
  String? sdkErrorMessage;
  String? sdkErrorDescription;

  @override
  void initState() {
    if (mounted) {
      setState(() {
        isCardListLoading = true;
      });
    }
    getUserInfo();
    Common.getCurrency().then((value) => setState(() => currency = value));
    cartItem = widget.cartItems;
    if (cartItem['walletAmount'] > 0) {
      walletUsedOrNotValue = true;
      if (cartItem['grandTotal'] == 0) {
        fullWalletUsedOrNot = true;
      }
    }
    super.initState();
  }

  Future<void> configureApp() async {
    GoSellSdkFlutter.configureApp(
      bundleId: Constants.bundleId,
      productionSecreteKey: Constants.tapProductionSecretKey!,
      sandBoxsecretKey: Constants.tapSandBoxSecretKey!,
      lang: widget.locale ?? 'en',
    );
  }

  Future<void> setupSDKSession() async {
    try {
      GoSellSdkFlutter.sessionConfigurations(
        allowedCadTypes: CardType.ALL,
        allowsToEditCardHolderName: true,
        cardHolderName:
            '${userInfo?['firstName'] ?? ''} ${userInfo?['lastName'] ?? ''}',
        trxMode: TransactionMode.TOKENIZE_CARD,
        transactionCurrency: currency!,
        amount: cartItem['grandTotal'].toDouble().toStringAsFixed(2),
        customer: Customer(
          customerId: '${userInfo?['_id'] ?? ''}',
          email: '${userInfo?['email'] ?? ''}',
          isdNumber: '${userInfo?['countryCode'] ?? ''} ',
          number: '${userInfo?['mobileNumber'] ?? ''}',
          firstName: '${userInfo?['firstName'] ?? ''}',
          middleName: "",
          lastName: '${userInfo?['lastName'] ?? ''}',
          metaData: null,
        ),
        paymentItems: <PaymentItem>[],
        taxes: [],
        shippings: [],
        postURL: "https://tap.company",
        paymentDescription: "paymentDescription",
        paymentMetaData: {"a": "a meta", "b": "b meta"},
        paymentReference: Reference(
          acquirer: "acquirer",
          gateway: "gateway",
          payment: "payment",
          track: "track",
          transaction: "transaction",
          order: "order",
        ),
        paymentStatementDescriptor: "paymentStatementDescriptor",
        isUserAllowedToSaveCard: true,
        isRequires3DSecure: false,
        receipt: Receipt(true, true),
        authorizeAction:
            AuthorizeAction(type: AuthorizeActionType.CAPTURE, timeInHours: 10),
        destinations: Destinations(
          currency: currency!,
          amount: double.parse(
              cartItem['grandTotal'].toDouble().toStringAsFixed(2)),
          count: cartItem['products'].length,
        ),
        merchantID: "",
        applePayMerchantID: "applePayMerchantID",
        allowsToSaveSameCardMoreThanOnce: false,
        paymentType: PaymentType.ALL,
        sdkMode: Constants.sdkModeType,
      );
      startSDK();
    } on PlatformException {
      AlertService().showToast(
          MyLocalizations.of(context)?.getLocalizations("PAYMENT_FAILED"));
    }

    if (!mounted) return;

    setState(() {
      tapSDKResult = {};
    });
  }

  Future<void> startSDK() async {
    tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;

    setState(() {
      switch (tapSDKResult?['sdk_result']) {
        case "SUCCESS":
          widget.data?['tapSourceId'] = tapSDKResult?['token'];
          palceOrderMethod(widget.data);
          break;
        case "FAILED":
          if (mounted) {
            setState(() {
              isPlaceOrderLoading = false;
            });
          }
          AlertService().showToast(
              MyLocalizations.of(context)?.getLocalizations("PAYMENT_FAILED"));
          break;
        case "CANCELLED":
          if (mounted) {
            setState(() {
              isPlaceOrderLoading = false;
            });
          }
          AlertService().showToast(MyLocalizations.of(context)
              ?.getLocalizations("PAYMENT_CANCELLED"));
          break;
        case "SDK_ERROR":
          if (mounted) {
            setState(() {
              isPlaceOrderLoading = false;
            });
          }
          sdkErrorCode = tapSDKResult?['sdk_error_code'].toString();
          sdkErrorMessage = tapSDKResult?['sdk_error_message'];
          sdkErrorDescription = tapSDKResult?['sdk_error_description'];
          if (sdkErrorCode != null) {
            AlertService().showToast(sdkErrorCode);
          } else if (sdkErrorMessage != null) {
            AlertService().showToast(sdkErrorMessage);
          } else if (sdkErrorDescription != null) {
            AlertService().showToast(sdkErrorDescription);
          } else {
            AlertService().showToast(MyLocalizations.of(context)
                ?.getLocalizations(MyLocalizations.of(context)
                    ?.getLocalizations('PLEASE_TRY_AGAIN_LATER')));
          }

          break;

        case "NOT_IMPLEMENTED":
          if (mounted) {
            setState(() {
              isPlaceOrderLoading = false;
            });
          }
          AlertService().showToast(MyLocalizations.of(context)
              ?.getLocalizations("PLEASE_TRY_AGAIN_LATER"));
          break;
      }
    });
  }

  getUserInfo() async {
    await LoginService.getUserInfo().then((onValue) {
      if (mounted) {
        setState(() {
          userInfo = onValue['response_data'];
          walletAmount = onValue['response_data']['walletAmount'] ?? 0;
          isCardListLoading = false;
          setPayment();
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

  setPayment() {
    paymentTypes.add('COD');
    if (Constants.stripKey != null && Constants.stripKey!.isNotEmpty) {
      setState(() {
        paymentTypes.add('STRIPE');
      });
    } else if (Constants.razorPayKey != null &&
        Constants.razorPayKey!.isNotEmpty) {
      setState(() {
        paymentTypes.add('RAZORPAY');
      });
    } else if (Constants.tapProductionSecretKey != null &&
        Constants.tapProductionSecretKey!.isNotEmpty &&
        Constants.tapSandBoxSecretKey != null &&
        Constants.tapSandBoxSecretKey!.isNotEmpty) {
      setState(() {
        paymentTypes.add('TAP');
        configureApp();
      });
    }
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
      widget.data?['paymentType'] = paymentTypes[groupValue!];
      widget.data?['deliveryInstruction'] = widget.instruction;
      if (fullWalletUsedOrNot == true) {
        widget.data!['paymentType'] = "COD";
        palceOrderMethod(widget.data);
      } else if (widget.data!['paymentType'] == "RAZORPAY") {
        try {
          await OrderService.getPaymentRazorOrderId().then((onValue) {
            _razorpay = Razorpay();
            var options = {
              'key': Constants.razorPayKey,
              'amount':
                  (100 * cartItem['grandTotal'].toDouble()).toStringAsFixed(2),
              'name': Constants.appName,
              'order_id': onValue['response_data']['paymentRazorOrderId'],
              'prefill': {
                'contact':
                    '${userInfo?['countryCode'] ?? ''} ${userInfo?['mobileNumber'] ?? ''}',
                'email': '${userInfo?['email'] ?? ''}'
              }
            };

            _razorpay?.open(options);
          });
          _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
          _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        } catch (e) {
          if (mounted) {
            setState(() {
              isPlaceOrderLoading = false;
              AlertService().showToast(e.toString());
            });
          }
        }
      } else if (widget.data?['paymentType'] == "TAP") {
        var code = await Common.getCurrencyCode();
        if (code.isNotEmpty) {
          final res = Constants.currencyList.any((element) => element == code);
          if (res) {
            setupSDKSession();
          } else {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
                AlertService().showToast(MyLocalizations.of(context)
                    ?.getLocalizations(
                        'ORDER_NOT_ACCEPTABLE_FOR_THIS_CURRENCY'));
              });
            }
          }
        }
      } else {
        palceOrderMethod(widget.data);
      }
    }
  }

  palceOrderMethod(cartData) async {
    await OrderService.placeOrder(cartData).then((onValue) async {
      if (cartData['paymentType'] == 'STRIPE') {
        await createOrderViaStripe(onValue['response_data']);
      } else if (cartData['paymentType'] == 'TAP') {
        if (onValue['response_data']['success'] == true &&
            onValue['response_data']['url'] != null) {
          Common.setCartDataCount(0);
          Common.setCartData(null);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WebViewOrderTapPay(
                locale: widget.locale,
                localizedValues: widget.localizedValues,
                orderId: onValue['response_data']['id'],
                tapUrl: onValue['response_data']['url'],
              ),
            ),
          );
        } else if (onValue['response_data']['success'] == true &&
            onValue['response_data']['url'] == null) {
          moveToNextPage(thanku: true);
        } else if (onValue['response_data']['success'] == false) {
          if (mounted) {
            setState(() {
              isPlaceOrderLoading = false;
              AlertService()
                  .showToast('${onValue['response_data']['message']}');
            });
          }
        }
      } else {
        moveToNextPage(thanku: true);
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

  Future<void> createOrderViaStripe(Map? res) async {
    if (res?['client_secret'] != null) {
      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: res?['client_secret'],
            merchantDisplayName: Constants.appName,
          ),
        );
        await Stripe.instance.presentPaymentSheet();
        moveToNextPage(thanku: true);
      } on Exception catch (e) {
        if (e is StripeException) {
          orderCancelMethod(res?['id'], message: '${e.error.message ?? ''}');
        } else {
          orderCancelMethod(res?['id']);
        }
      }
    } else {
      orderCancelMethod(res?['id']);
    }
  }

  orderCancelMethod(String orderId, {String? message}) async {
    await OrderService.orderCancel(orderId);
    moveToNextPage(message: message);
  }

  moveToNextPage({String? message, bool? thanku}) async {
    if (mounted) {
      setState(() {
        isPlaceOrderLoading = false;
        Common.setCartDataCount(0);
        Common.setCartData(null);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => (thanku == true
                    ? Thankyou(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                      )
                    : PaymentFailed(
                        message: message,
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                      ))),
            (Route<dynamic> route) => false);
      });
    }
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
      body: isCardListLoading
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
                      : paymentTypes.length > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildBoldText(context, "CHOOSE_PAYMENT_METHOD"),
                                SizedBox(height: 10),
                                ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: paymentTypes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      color: whiteBg(context),
                                      child: RadioListTile(
                                        value: index,
                                        groupValue: groupValue,
                                        selected: isSelected,
                                        activeColor: primary(context),
                                        title: textGreenprimary(
                                            context,
                                            paymentTypes[index],
                                            TextStyle(color: primarybg)),
                                        onChanged: (int? selected) {
                                          if (mounted) {
                                            setState(() {
                                              groupValue = selected;
                                            });
                                          }
                                        },
                                        secondary: paymentTypes[index] == "COD"
                                            ? Text(currency ?? '',
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
      bottomNavigationBar: !isCardListLoading && paymentTypes.length > 0
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

  _handlePaymentSuccess(PaymentSuccessResponse? response) {
    var razorPayDetails = {
      'paymentId': response?.paymentId,
      'signature': response?.signature,
      'orderId': response?.orderId
    };
    setState(() {
      widget.data?['razorPayDetails'] = razorPayDetails;
      widget.data?['paymentId'] = response?.paymentId;
    });
    _razorpay?.clear();
    palceOrderMethod(widget.data);
  }

  _handlePaymentError(PaymentFailureResponse response) async {
    if (mounted) {
      setState(() {
        isPlaceOrderLoading = false;
        AlertService().showToast(
            '${(response.message is String ? response.message : response.message != null ? jsonDecode(response.message!)['error']['description'] ?? '' : '')}');
        _razorpay?.clear();
      });
    }
  }
}
