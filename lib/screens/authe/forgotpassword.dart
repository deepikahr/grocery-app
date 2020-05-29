import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:readymadeGroceryApp/screens/authe/otp.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';

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
  String email;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVerfyEmailLoading = false;
  verifyEmail() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isVerfyEmailLoading = true;
        });
      }
      Map<String, dynamic> body = {"email": email.toLowerCase()};
      await LoginService.verifyEmail(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isVerfyEmailLoading = false;
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
                        new Text(
                          '${onValue['response_data']['message']}',
                          style: textBarlowMediumBlack(),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text(
                        MyLocalizations.of(context).ok,
                        style: textbarlowRegularaPrimary(),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Otp(
                              email: email.toLowerCase(),
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
          if (mounted) {
            setState(() {
              isVerfyEmailLoading = false;
            });
          }
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isVerfyEmailLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    } else {
      if (mounted) {
        setState(() {
          isVerfyEmailLoading = false;
        });
      }
      return;
    }
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
          MyLocalizations.of(context).forgotPassword,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 40.0, left: 18.0, bottom: 8.0, right: 20.0),
                child: Text(
                  MyLocalizations.of(context).passwordreset,
                  style: textbarlowMediumBlack(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, bottom: 25.0, right: 20.0),
                child: Text(
                  MyLocalizations.of(context)
                      .pleaseenteryourregisteredEmailtosendtheresetcode,
                  style: textbarlowRegularBlack(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: GFTypography(
                  showDivider: false,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: MyLocalizations.of(context).email,
                            style: textbarlowRegularBlack()),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 10.0, left: 20.0, right: 20.0),
                child: Container(
                  child: TextFormField(
                    onSaved: (String value) {
                      email = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context).enterYourEmail;
                      } else if (!RegExp(
                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value)) {
                        return MyLocalizations.of(context)
                            .pleaseEnterValidEmail;
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
              Container(
                height: 55,
                margin:
                    EdgeInsets.only(top: 30, bottom: 20, right: 20, left: 20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.29), blurRadius: 5)
                ]),
                child: GFButton(
                  color: primary,
                  size: GFSize.LARGE,
                  blockButton: true,
                  onPressed: verifyEmail,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).submit,
                        style: textBarlowRegularrBlack(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isVerfyEmailLoading
                          ? GFLoader(
                              type: GFLoaderType.ios,
                            )
                          : Text("")
                    ],
                  ),
                ),
              ),
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
