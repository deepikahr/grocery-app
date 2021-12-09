import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/alert-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

SentryError sentryError = new SentryError();

class AddMoney extends StatefulWidget {
  final Map? localizedValues, userInfo;
  final String? locale;

  AddMoney({Key? key, this.locale, this.localizedValues, this.userInfo});

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  String currency = "";
  double? walletAmount;
  bool isAddMoneyLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Razorpay? _razorpay;
  final TextEditingController addMoneyController = new TextEditingController();

  @override
  void initState() {
    Common.getCurrency().then((value) => setState(() => currency = value));
    super.initState();
  }

  addMoney() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      FocusScope.of(context).unfocus();
      setState(() {
        isAddMoneyLoading = true;
      });
      Map body = {
        "amount": walletAmount,
        "userFrom": Constants.orderFrom,
        "paymentType": "STRIPE"
      };
      await OrderService.addMoneyApi(body).then((onValue) {
        if (mounted) {
          setState(() {
            createAddMoneyToWalletViaStripe(onValue['response_data']);
          });
        }
      }).catchError((error) {
        setState(() {
          isAddMoneyLoading = false;
        });
      });
    }
  }

  addMoneyVaiRazorpay() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      FocusScope.of(context).unfocus();
      setState(() {
        isAddMoneyLoading = true;
      });
      Map body = {
        "amount": walletAmount,
        "userFrom": Constants.orderFrom,
        "paymentType": "RAZORPAY"
      };
      await OrderService.addMoneyRazorPayId(body).then((onValue) {
        try {
          _razorpay = Razorpay();
          var options = {
            'key': Constants.razorPayKey,
            'amount': (100 * walletAmount!).toStringAsFixed(2),
            'name': Constants.appName,
            'order_id': onValue['response_data']['generatedId'],
            'prefill': {
              'contact':
                  '${widget.userInfo?['countryCode'] ?? ''} ${widget.userInfo?['mobileNumber'] ?? ''}',
              'email': '${widget.userInfo?['email'] ?? ''}'
            }
          };
          _razorpay?.open(options);
          _razorpay?.on(
              Razorpay.EVENT_PAYMENT_SUCCESS,
              (response) => _handlePaymentSuccess(
                  response, onValue['response_data']['walletId']));
          _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        } catch (e) {
          moveToNextPage();
        }
      }).catchError((onError) {
        if (mounted) {
          setState(() {
            isAddMoneyLoading = false;
          });
        }
      });
    }
  }

  _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      setState(() {
        isAddMoneyLoading = false;
        AlertService().showToast((response.message is String
            ? response.message
            : response.message != null
                ? jsonDecode(response.message!)['error']['description'] ?? ''
                : ''));
        _razorpay?.clear();
      });
    }
  }

  Future<void> createAddMoneyToWalletViaStripe(Map? res) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: res?['client_secret'],
        merchantDisplayName: Constants.appName,
      ),
    );

    if (res?['client_secret'] != null) {
      try {
        await Stripe.instance.presentPaymentSheet();
        moveToNextPage(isThanku: true);
        addMoneyController.clear();
      } on Exception catch (e) {
        if (e is StripeException) {
          moveToNextPage(message: '${e.error.message ?? ''}');
        }
        if (e is PlatformException) {
          moveToNextPage(message: e.message);
        }
      }
    } else {
      moveToNextPage();
    }
  }

  moveToNextPage({String? message, bool? isThanku}) {
    setState(() {
      isAddMoneyLoading = false;
    });
    if (isThanku == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => (Thankyou(
            locale: widget.locale,
            localizedValues: widget.localizedValues,
            isWallet: true,
          )),
        ),
      );
    } else {
      if (message != null) {
        AlertService()
            .showToast(MyLocalizations.of(context)!.getLocalizations(message));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar:
            appBarPrimarynoradius(context, "ADD_MONEY") as PreferredSizeWidget?,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 40),
                  buildImageView(),
                  buildAddMoneyTextDescription(),
                  buildLabelText(),
                  buildTextField(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80.0,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                    if (Constants.stripKey != null &&
                        Constants.stripKey!.isNotEmpty) {
                      addMoney();
                    } else if (Constants.razorPayKey != null &&
                        Constants.razorPayKey!.isNotEmpty) {
                      addMoneyVaiRazorpay();
                    }
                  },
                  child: regularbuttonPrimary(
                      context, "ADD_MONEY", isAddMoneyLoading)),
              SizedBox(height: 4),
            ],
          ),
        ),
      );

  Widget buildLabelText() {
    return buildGFTypography(context, "AMOUNT", true, true);
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        controller: addMoneyController,
        onSaved: (String? value) {
          if (value!.length > 0) {
            walletAmount = double.parse(value);
          }
        },
        validator: (String? value) {
          if (value == null) {
            return MyLocalizations.of(context)!
                .getLocalizations("ENTER_ADD_VALID_AMOUNT");
          } else if (value.isEmpty || value == '0') {
            return MyLocalizations.of(context)!
                .getLocalizations("ENTER_ADD_VALID_AMOUNT");
          } else if (double.parse(value) < 1) {
            return MyLocalizations.of(context)!
                .getLocalizations("ENTER_MIN_1_AMOUNT");
          } else {
            return null;
          }
        },
        style: textBarlowRegularBlack(context),
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: false),
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Color(0xFFF44242),
            ),
          ),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 12),
            child: Text(
              MyLocalizations.of(context)!.getLocalizations(currency, true),
              style: textbarlowmediumwblack(context),
            ),
          ),
          hintText: "00.00",
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary(context)),
          ),
        ),
      ),
    );
  }

  buildImageView() =>
      Image.asset('lib/assets/images/addMoney.png', height: 300);

  buildAddMoneyTextDescription() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          MyLocalizations.of(context)!.getLocalizations(
              "PLEASE_ENTER_THE_AMOUNT_YOU_WANT_TO_ADD_IN_THE_WALLET"),
          style: textBarlowRegularBlack(context),
          textAlign: TextAlign.center,
        ),
      );
  _handlePaymentSuccess(
      PaymentSuccessResponse? response, String? walletId) async {
    var razorPayDetails = {
      'amount': walletAmount,
      'paymentType': 'RAZORPAY',
      'walletId': walletId,
      'paymentId': response?.paymentId,
      'signature': response?.signature,
      'generatedId': response?.orderId,
      'userFrom': Constants.orderFrom,
    };
    _razorpay?.clear();

    await OrderService.addMoneyApi(razorPayDetails).then((value) {
      if (mounted) {
        setState(() {
          isAddMoneyLoading = false;
          addMoneyController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Thankyou(
                locale: widget.locale,
                localizedValues: widget.localizedValues,
                isWallet: true,
              ),
            ),
          );
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isAddMoneyLoading = false;
        });
      }
    });
  }
}
