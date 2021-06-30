import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:readymade_grocery_app/screens/authe/resetPas.dart';
import 'package:readymade_grocery_app/service/localizations.dart';
import 'package:readymade_grocery_app/service/otp-service.dart';
import 'package:readymade_grocery_app/service/sentry-service.dart';
import 'package:readymade_grocery_app/style/style.dart';
import 'package:readymade_grocery_app/widgets/appBar.dart';
import 'package:readymade_grocery_app/widgets/button.dart';
import 'package:readymade_grocery_app/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class Otp extends StatefulWidget {
  Otp(
      {Key? key,
      this.locale,
      this.localizedValues,
      this.signUpTime,
      this.resentOtptime,
      this.mobileNumber,
      this.sId})
      : super(key: key);
  final String? locale, mobileNumber, sId;
  final Map? localizedValues;
  final bool? signUpTime, resentOtptime;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? enteredOtp, sid;
  bool isOtpVerifyLoading = false, isResentOtpLoading = false;
  @override
  void initState() {
    sid = widget.sId ?? null;
    super.initState();
  }

  verifyOTPwithMobile() async {
    if (enteredOtp != null) {
      final form = _formKey.currentState;
      if (form!.validate()) {
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
        await OtpService.verifyOtpWithNumber(body).then((onValue) {
          if (onValue['response_data'] != null &&
              onValue['verificationToken'] != null) {
            if (mounted) {
              setState(() {
                isOtpVerifyLoading = false;
              });
            }
            showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return new AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text(onValue['response_data'],
                            style: textBarlowMediumBlack(context)),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text(
                          MyLocalizations.of(context)!.getLocalizations("OK"),
                          style: TextStyle(color: green)),
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
                                  token: onValue['verificationToken'],
                                  mobileNumber: widget.mobileNumber,
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues),
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
          MyLocalizations.of(context)!.getLocalizations("OTP_MSG_MOBILE"));
    }
  }

  showAlert(message) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            MyLocalizations.of(context)!.getLocalizations("ERROR"),
            style: hintSfMediumredsmall(context),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(
                  '$message',
                  style: textBarlowRegularBlack(context),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                MyLocalizations.of(context)!.getLocalizations("OK"),
                style: textbarlowRegularaprimary(context),
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

    OtpService.resendOtpWithNumber(widget.mobileNumber).then((response) {
      if (mounted) {
        setState(() {
          showSnackbar(response['response_data']);
          sid = response['sId'] ?? null;
          isResentOtpLoading = false;
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
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "WELCOME") as PreferredSizeWidget,
      body: ListView(
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: buildBoldText(context, "VERIFY_OTP")),
          Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: buildGFTypographyOtp(context, "OTP_CODE_MSG", '')),
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
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: true,
                obscuringCharacter: '*',
                obscuringWidget: FlutterLogo(
                  size: 24,
                ),
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  if (v!.length < 6) {
                    return MyLocalizations.of(context)!
                        .getLocalizations('ENTER_6_DIGITS_OTP');
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                ),
                cursorColor: Colors.black,
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                onCompleted: (String pin) {
                  if (mounted) {
                    setState(() {
                      enteredOtp = pin;
                    });
                  }
                },
                onChanged: (String value) {
                  if (mounted) {
                    setState(() {
                      enteredOtp = value;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }
}
