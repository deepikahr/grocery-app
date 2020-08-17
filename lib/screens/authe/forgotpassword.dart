import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';

import 'package:readymadeGroceryApp/screens/authe/otp.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';

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

      await LoginService.forgetPassword(email.toLowerCase()).then((onValue) {
        if (mounted) {
          setState(() {
            isVerfyEmailLoading = false;
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
                          email: email.toLowerCase(),
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
      appBar: appBarPrimary(context,
          MyLocalizations.of(context).getLocalizations("FORGET_PASSWORD")),
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 40.0, left: 18.0, bottom: 8.0, right: 20.0),
                child: Text(
                  MyLocalizations.of(context)
                      .getLocalizations("PASSWORD_RESET"),
                  style: textbarlowMediumBlack(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, bottom: 25.0, right: 20.0),
                child: Text(
                  MyLocalizations.of(context)
                      .getLocalizations("FORET_PASS_MESSAGE"),
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
                            text: MyLocalizations.of(context)
                                .getLocalizations("EMAIL", true),
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
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_YOUR_EMAIL");
                      } else if (!RegExp(
                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value)) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ERROR_MAIL");
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
                        MyLocalizations.of(context).getLocalizations("SUBMIT"),
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
