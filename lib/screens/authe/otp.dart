import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:grocery_pro/screens/authe/resetPas.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

SentryError sentryError = new SentryError();

class Otp extends StatefulWidget {
  Otp({Key key, this.email, this.token, this.locale, this.localizedValues})
      : super(key: key);
  final String email, token;
  final Map<String, Map<String, String>> localizedValues;
  final String locale;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String enteredOtp;
  bool isOtpVerifyLoading = false, isEmailLoading = false;
  verifyEmail() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isEmailLoading = true;
        });
      }
      Map<String, dynamic> body = {"email": widget.email};
      await LoginService.verifyEmail(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isEmailLoading = false;
            });
          }
          if (onValue['response_code'] == 200) {
          } else if (onValue['response_code'] == 400) {
            showAlert('${onValue['response_data']}');
          } else {}
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else {
      return;
    }
  }

  verifyOTP() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isOtpVerifyLoading = true;
        });
      }
      Map<String, dynamic> body = {"otp": enteredOtp};
      await LoginService.verifyOtp(body, widget.token).then((onValue) {
        print(onValue);
        try {
          if (mounted) {
            setState(() {
              isOtpVerifyLoading = false;
            });
          }
          if (onValue['response_code'] == 200) {
            showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return new AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('${onValue['response_data']['message']}'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('OK'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPassword(
                              token: onValue['response_data']['token'],
                              locale: widget.locale,
                              localizedValues: widget.localizedValues,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else if (onValue['response_code'] == 401) {
            showSnackbar('${onValue['response_data']}');
          } else {
            showSnackbar('${onValue['response_data']}');
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else {
      return;
    }
  }

  showAlert(message) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("error"),
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
                'OK',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Text(
          'Welcome',
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color:Colors.black),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 15.0,
            ),
            child: Text(
              "Verify OTP",
              style: textbarlowMediumBlack(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "We have sent a 4 digit code to",
                      style: textBarlowRegularBlack()),
                  TextSpan(
                    text: ' ${widget.email}',
                    style: textBarlowMediumGreen(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 5.0, left: 20.0),
            child: GFTypography(
              showDivider: false,
              child: Text(
                'Enter Verification code',
                style: textBarlowRegularBlack(),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              width: 800,
              child: PinEntryTextField(
                showFieldAsBox: true,
                fieldWidth: 40.0,
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
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: GFButton(
              color: primary,
              onPressed: verifyOTP,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Submit OTP",
                    style: textbarlowMediumBlack(),
                  ),
                  isOtpVerifyLoading
                      ? Image.asset(
                          'lib/assets/images/spinner.gif',
                          width: 15.0,
                          height: 15.0,
                          color: Colors.black,
                        )
                      : Text("")
                ],
              ),
              textStyle: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
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
