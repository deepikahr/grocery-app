import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/otp-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class ResetPassword extends StatefulWidget {
  final String? locale, mobileNumber, token;
  final Map? localizedValues;
  ResetPassword(
      {Key? key,
      this.token,
      this.localizedValues,
      this.locale,
      this.mobileNumber})
      : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? newpassword;
  String? confirmpassword;
  bool success = false, passwordVisible = true, passwordVisible1 = true;

  bool isResetPasswordLoading = false;

  resetPassword() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isResetPasswordLoading = true;
        });
      }
      Map<String, dynamic> body = {
        "newPassword": newpassword,
        "mobileNumber": widget.mobileNumber,
        "verificationToken": widget.token
      };
      await OtpService.resetPasswordWithNumber(body).then((onValue) {
        if (mounted) {
          setState(() {
            isResetPasswordLoading = false;
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
                        style: textBarlowRegularBlack(context)),
                  ],
                ),
              ),
              actions: <Widget>[
                GFButton(
                  color: Colors.transparent,
                  child: new Text(
                      MyLocalizations.of(context)!.getLocalizations("OK"),
                      style: textbarlowRegularaprimary(context)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isResetPasswordLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    } else {
      if (mounted) {
        setState(() {
          isResetPasswordLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "RESET") as PreferredSizeWidget?,
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: buildGFTypography(context, "ENTER_PASSWORD", true, true),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
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
                        suffixIcon: InkWell(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                passwordVisible1 = !passwordVisible1;
                              });
                            }
                          },
                          child: Icon(Icons.remove_red_eye, color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context)),
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("ENTER_PASSWORD");
                        } else if (value.length < 6) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("ERROR_PASS");
                        } else
                          return null;
                      },
                      controller: _passwordTextController,
                      onSaved: (String? value) {
                        newpassword = value;
                      },
                      obscureText: passwordVisible1),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: buildGFTypography(
                    context, "RE_ENTER_NEW_PASSWORD", true, true),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xFFF44242),
                          ),
                        ),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        contentPadding: EdgeInsets.all(10),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            }
                          },
                          child: Icon(Icons.remove_red_eye, color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context)),
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("ENTER_PASSWORD");
                        } else if (value.length < 6) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("ERROR_PASS");
                        } else if (_passwordTextController.text != value) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("PASS_NOT_MATCH");
                        } else
                          return null;
                      },
                      onSaved: (String? value) {
                        confirmpassword = value;
                      },
                      obscureText: passwordVisible),
                ),
              ),
              InkWell(
                  onTap: resetPassword,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: buttonprimary(
                        context, "SUBMIT", isResetPasswordLoading),
                  )),
            ],
          ),
        ),
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
