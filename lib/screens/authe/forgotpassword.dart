import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/authe/otp.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/otp-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title, this.locale, this.localizedValues})
      : super(key: key);
  final String title, locale;
  final Map localizedValues;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email, mobileNumber;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVerifyMobileLoading = false;

  verifyContactNumber() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isVerifyMobileLoading = true;
        });
      }
      Map body = {
        "number": mobileNumber.toString(),
      };
      await OtpService.resendOtpWithNumber(body).then((onValue) {
        if (mounted) {
          setState(() {
            isVerifyMobileLoading = false;
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
                    new Text('${onValue['response_data']}',
                        style: textBarlowRegularBlack()),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    MyLocalizations.of(context).getLocalizations("SUBMIT"),
                    style: textbarlowRegularaPrimary(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Otp(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          mobileNumber: mobileNumber,
                          sId: onValue['sId'],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isVerifyMobileLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    } else {
      if (mounted) {
        setState(() {
          isVerifyMobileLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "FORGET_PASSWORD"),
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child:
                    buildGFTypography(context, "PASSWORD_RESET", false, false),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 25.0, right: 20.0),
                  child: normalTextWithOutRow(
                      context, "FORET_PASS_MOBILE_MSG", false)),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: buildGFTypography(context, "CONTACT_NUMBER", true, true),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 10.0, left: 20.0, right: 20.0),
                child: Container(
                  child: TextFormField(
                    onSaved: (String value) {
                      mobileNumber = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_YOUR_CONTACT_NUMBER");
                      } else
                        return null;
                    },
                    style: textBarlowRegularBlack(),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Color(0xFFF44242))),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        contentPadding: EdgeInsets.all(10),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        )),
                  ),
                ),
              ),
              InkWell(
                  onTap: verifyContactNumber,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                        buttonPrimary(context, "SUBMIT", isVerifyMobileLoading),
                  )),
            ],
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
