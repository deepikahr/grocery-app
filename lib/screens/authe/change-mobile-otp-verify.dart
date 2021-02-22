import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/otp-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class ChangeMobileNumberOtpVerify extends StatefulWidget {
  ChangeMobileNumberOtpVerify(
      {Key key, this.locale, this.localizedValues, this.sId, this.mobileNumber})
      : super(key: key);
  final String locale, mobileNumber, sId;
  final Map localizedValues;

  @override
  _ChangeMobileNumberOtpVerifyState createState() =>
      _ChangeMobileNumberOtpVerifyState();
}

class _ChangeMobileNumberOtpVerifyState
    extends State<ChangeMobileNumberOtpVerify> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String enteredOtp, sid;
  bool isOtpVerifyLoading = false;
  @override
  void initState() {
    sid = widget.sId ?? null;
    super.initState();
  }

  verifyOTPwithMobile() async {
    if (enteredOtp != null) {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        if (mounted) {
          setState(() {
            isOtpVerifyLoading = true;
          });
        }
        Map body = {
          "otp": enteredOtp,
          "mobileNumber": widget.mobileNumber.toString()
        };
        if (sid != null) {
          body['sId'] = sid;
        }

        await OtpService.changePasswordVerifyOtpWithNumber(body)
            .then((onValue) {
          if (onValue['response_data'] != null) {
            showSnackbar(onValue['response_data'] ?? "");
            Common.getSelectedLanguage().then((selectedLocale) async {
              Map body = {"language": selectedLocale, "playerId": null};
              LoginService.updateUserInfo(body).then((value) async {
                await Common.setToken(null);
                await Common.setUserID(null);
                await Common.setCartDataCount(0);
                await Common.setCartData(null);
                if (mounted) {
                  setState(() {
                    isOtpVerifyLoading = false;
                  });
                }
                Future.delayed(Duration(milliseconds: 1500), () {
                  var result = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Login(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues),
                    ),
                  );
                  result.then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Home(
                              locale: widget.locale,
                              localizedValues: widget.localizedValues,
                              currentIndex: 0),
                        ),
                        (Route<dynamic> route) => false);
                  });
                });
              });
            });
          } else {
            if (mounted) {
              setState(() {
                isOtpVerifyLoading = false;
                showSnackbar('${onValue['response_data']}');
              });
            }
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              isOtpVerifyLoading = false;
            });
          }
          sentryError.reportError(error, null);
        });
      } else {
        return;
      }
    } else {
      if (mounted) {
        setState(() {
          isOtpVerifyLoading = false;
        });
      }
      showSnackbar(
          MyLocalizations.of(context).getLocalizations("OTP_MSG_MOBILE"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "WELCOME"),
      body: ListView(
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: buildBoldText(context, "VERIFY_OTP")),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: buildGFTypographyOtp(
                context, "OTP_CODE_MSG", ' ${widget.mobileNumber}'),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5.0, left: 20.0, right: 20.0),
            child: buildGFTypography(
                context, "ENTER_VERIFICATION_CODE", true, true),
          ),
          Form(
            key: _formKey,
            child: Container(
              width: 800,
              child: PinEntryTextField(
                showFieldAsBox: true,
                fieldWidth: 40.0,
                fields: 6,
                onSubmit: (String pin) {
                  if (mounted) {
                    setState(() {
                      enteredOtp = pin;
                    });
                  }
                },
              ),
            ),
          ),
          InkWell(
              onTap: verifyOTPwithMobile,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: buttonprimary(context, "SUBMIT", isOtpVerifyLoading),
              )),
        ],
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
