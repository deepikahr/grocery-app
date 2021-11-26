import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:readymadeGroceryApp/screens/thank-you/payment-failed.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
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
  double? walletAmmount;
  bool isAddMoneyLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Razorpay? _razorpay;

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
        "amount": walletAmmount,
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
        "amount": walletAmmount,
        "userFrom": Constants.orderFrom,
        "paymentType": "RAZORPAY"
      };
      await OrderService.addMoneyRazorPayId(body).then((onValue) {
        try {
          _razorpay = Razorpay();
          var options = {
            'key': Constants.razorPayKey,
            'amount': (100 * walletAmmount!).toStringAsFixed(2),
            'name': Constants.appName,
            'order_id': onValue['response_data']['generatedId'],
            'timeout': 300,
            'prefill': {
              'contact': widget.userInfo?['mobileNumber'],
              'email': widget.userInfo?['email']
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
    moveToNextPage(message: response.message ?? '');
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
      } on Exception catch (e) {
        if (e is StripeException) {
          moveToNextPage(message: '${e.error.message ?? ''}');
        } else {
          moveToNextPage();
        }
      }
    } else {
      moveToNextPage();
    }
  }

  moveToNextPage({String? message, bool? isThanku}) {
    setState(() {
      isAddMoneyLoading = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => (isThanku == true
              ? Thankyou(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isWallet: true,
                )
              : PaymentFailed(
                  message: message,
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                )),
        ),
      );
    });
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
                    }
                    if (Constants.razorPayKey != null &&
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
    return buildGFTypography(context, "AMOUNT", false, false);
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        onSaved: (String? value) {
          if (value!.length > 0) {
            walletAmmount = double.parse(value);
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
        keyboardType: TextInputType.number,
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
      'amount': walletAmmount,
      'paymentType': 'RAZORPAY',
      'walletId': walletId,
      'paymentId': response?.paymentId,
      'signature': response?.signature,
      'generatedId': response?.orderId,
      'userFrom': Constants.orderFrom,
    };
    await OrderService.addMoneyApi(razorPayDetails).then((value) {
      if (mounted) {
        setState(() {
          isAddMoneyLoading = false;
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
