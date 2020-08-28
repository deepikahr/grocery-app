import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/authe/resetPas.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/otp-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class Otp extends StatefulWidget {
  Otp(
      {Key key,
      this.email,
      this.token,
      this.locale,
      this.localizedValues,
      this.signUpTime,
      this.resentOtptime,
      this.mobileNumber,
      this.sid})
      : super(key: key);
  final String email, token, locale, mobileNumber;
  final Map localizedValues;
  final bool signUpTime, resentOtptime;
  final sid;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String enteredOtp;
  bool isOtpVerifyLoading = false,
      isEmailLoading = false,
      isResentOtpLoading = false;

  verifyOTP() async {
    if (enteredOtp != null) {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        if (mounted) {
          setState(() {
            isOtpVerifyLoading = true;
          });
        }
         Map<String, dynamic> body = {
          "otp": enteredOtp,
          "sid": widget.sid,
          "mobileNumber": widget.mobileNumber.toString()
        };
        await OtpService.verifyOtp(body).then((onValue) {
          if (mounted) {
            setState(() {
              isOtpVerifyLoading = false;
            });
          }
          if (onValue['response_data'] != null) {
            showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return new AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text(
                          onValue['response_data'],
                          style: textBarlowMediumBlack(),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text(
                        'OK',
                        style: TextStyle(color: green),
                      ),
                      onPressed: () {
                         if (widget.signUpTime == true) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          } else if (widget.resentOtptime == true) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPassword(
                                  token: widget.token,
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                ),
                              ),
                            );
                          }
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showSnackbar('${onValue['response_data']}');
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
      showSnackbar(MyLocalizations.of(context).getLocalizations("OTP_MSG"));
    }
  }

  showAlert(message) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            MyLocalizations.of(context).getLocalizations("ERROR"),
            style: hintSfMediumredsmall(),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(
                  '$message',
                  style: textBarlowRegularBlack(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                MyLocalizations.of(context).getLocalizations("OK"),
                style: textbarlowRegularaPrimary(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  resentOTP() async {
    if (mounted) {
      setState(() {
        isResentOtpLoading = true;
      });
    }

    await LoginService.forgetPassword(widget.email.toLowerCase())
        .then((response) {
      if (mounted) {
        setState(() {
          isResentOtpLoading = false;
          showSnackbar(response['response_data']);
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isResentOtpLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child:
                buildGFTypographyOtp(context, "CODE_MSG", ' ${widget.mobileNumber}'),
          ),
          InkWell(
              onTap: resentOTP,
              child: buildResentOtp(context, "RESENT_OTP", isResentOtpLoading)),
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
              onTap: verifyOTP,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: buttonPrimary(context, "SUBMIT", isOtpVerifyLoading),
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
